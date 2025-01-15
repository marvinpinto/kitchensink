#!/usr/bin/env python3
import signal
import requests
import logging
import dns
import dns.reversename
import dns.resolver
import subprocess
import os
import sys
import time


# globals
should_loop = True
logger = logging.getLogger(__name__)


def setup_logging(level='INFO'):
    log_format = '%(asctime)s %(levelname)-8s %(message)s'
    log_level = os.environ.get('LOG_LEVEL', level).upper()
    datefmt = '%Y-%m-%d_%H:%M:%S'

    logging.basicConfig(
        stream = sys.stdout,
        format = log_format,
        level = log_level,
        datefmt = datefmt,
    )

    logging.getLogger('urllib3').setLevel(logging.ERROR)
    if os.environ.get('LOG_LEVEL', level).upper() == 'DEBUG':
        logging.getLogger('urllib3').setLevel(logging.DEBUG)


def handle_signal(signum, frame):
    global should_loop
    signame = signal.Signals(signum).name
    logger.debug('Signal handler called with signal {} ({})'.format(signame, signum))
    should_loop = False


def get_public_ip():
    s = requests.Session()
    try:
        logger.debug('Retrieving public IP address from gluetun')
        r = s.get('http://127.0.0.1:8000/v1/publicip/ip')
        r.raise_for_status()
        public_ip = r.json().get('public_ip')
        return public_ip
    except requests.exceptions.RequestException as e:
        logger.error('Unable to retrieve public IP address: {} - {}'.format(e, e.response.text))
        return None


def is_ip_blocklisted(ip_addr):
    lists = [
        'dnsbl.dronebl.org',
    ]

    for service in lists:
        logger.debug('Checking to see if IP "{}" is blocklisted with service "{}"'.format(ip_addr, service))
        lookup_name = dns.reversename.from_address(ip_addr, dns.name.from_text(service))
        try:
            resolver = dns.resolver.Resolver()
            resolver.nameservers = ['8.8.8.8', '1.1.1.1']
            resolver.lifetime = 5
            answer = resolver.resolve(lookup_name, 'A', raise_on_no_answer=False)
            if answer.rrset is not None:
                logger.warning('IP address "{}" appears to be blocklisted on list "{}"'.format(ip_addr, service))
                return True
        except dns.resolver.NXDOMAIN:
            logger.debug('IP address "{}" does not appear to be blocklisted on list "{}"'.format(ip_addr, service))
            continue
        except dns.exception.DNSException as dnse:
            logger.error('Unable to lookup records for "{}": {}'.format(lookup_name, dnse))
            continue
    logger.info('IP address "{}" does not appear to be blocklisted in any of the lists we checked'.format(ip_addr))
    return False


def exec_process(cmdline):
    try:
        logger.debug('Attempting to run utility: {}'.format(' '.join(cmdline)))
        res = subprocess.run(
            cmdline,
            capture_output = True,
            text = True,
        )
        logger.debug('utility - stdout: "{}", stderr: "{}"'.format(res.stdout, res.stderr))
        res.check_returncode()
    except Exception as e:
        logger.error('Error when attempting to run utility "{}": {}'.format(' '.join(cmdline), e))
        return False
    return True


def service_loop():
    global should_loop
    previous_ip_addr = None

    while should_loop:
        time.sleep(60)

        current_ip_addr = get_public_ip()
        if not current_ip_addr:
            logger.debug('IP address "{}" is not yet available, nothing to do here'.format(current_ip_addr))
            continue
        if current_ip_addr == previous_ip_addr:
            logger.debug('IP address "{}" has not changed since last run, nothing to do here'.format(current_ip_addr))
            continue

        logger.info('Checking the blocklist status for IP: {}'.format(current_ip_addr))
        if is_ip_blocklisted(current_ip_addr):
            logger.info('Restarting the gluetun VPN process')
            cmdline = ['/usr/bin/s6-svc', '-ruwr', '/var/run/service/svc-gluetun']
            if not exec_process(cmdline):
                logger.error('Unable to restart the gluetun VPN process')
                continue

        previous_ip_addr = current_ip_addr


def main():
    setup_logging(level='INFO')
    logger.info('Initializing DNS blocklist checker')
    signal.signal(signal.SIGINT, handle_signal)
    service_loop()
    logger.info('DNS blocklist checker complete')


if __name__ == '__main__':
    main()
