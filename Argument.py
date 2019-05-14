import argparse
import sys
import ConfigOperation


def check_arg(args=None):
    parser = argparse.ArgumentParser(description='Deployment History Configuration file maintenance')
    parser.add_argument('-p', '--path',
                        help='config file path',
                        #                       required='True',
                        default='deployment_history.ini')
    parser.add_argument('-s', '--section',
                        help='section in config file',
                        required='True',
                        default='default')
    parser.add_argument('-k', '--key',
                        help='Add key to section in config file',
                        required='True')
    parser.add_argument('-v', '--value',
                        help='Add value to key for section in config file',
                        required='True')

    results = parser.parse_args(args)

    return (results.path, results.section, results.key, results.value)


if __name__ == '__main__':

    p, s, k, v = check_arg(sys.argv[1:])
    print('path = ' + p)
    print('section = ' + s)
    print('key = ' + k)
    print('value = ' + v)
    ConfigOperation.add_setting(p, s, k, v)