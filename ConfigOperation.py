import ConfigParser
from ConfigParser import Error as ConfigError
import os


def createDefaultConfig(path):
    """
    Create a config file
    """
    config = ConfigParser.ConfigParser()
    config.add_section("Settings")
    config.set("Settings", "font", "Courier")
    config.set("Settings", "font_size", "10")
    config.set("Settings", "font_style", "Normal")
    config.set("Settings", "font_info",
               "You are using %(font)s at %(font_size)s pt")

    with open(path, "wb") as config_file:
        config.write(config_file)


def createConfigOnParam(path, section, setting, value):
    """
    :param path:
    :param section:
    :param setting:
    :param value:
    :return:
    """
    config = ConfigParser.ConfigParser()
    config.add_section(section)
    config.set(section, setting, value)

    with open(path, "wb") as config_file:
        config.write(config_file)


def get_config_on_param(path, section, setting, value):

    if not os.path.exists(path):
        createConfigOnParam(path, section, setting, value)

    config = ConfigParser.ConfigParser()
    config.read(path)
    return config


def get_config(path):
    """
    Returns the config object
    """
    if not os.path.exists(path):
        createDefaultConfig(path)

    config = ConfigParser.ConfigParser()
    config.read(path)
    return config


def get_setting(path, section, setting):
    """
    Print out a setting
    """
    config = get_config(path)
    value = config.get(section, setting)
    print "{section} {setting} is {value}".format(
        section=section, setting=setting, value=value)
    return value


def add_setting(path, section, setting, value):

    """
    :param path:
    :param section:
    :param setting:
    :param value:
    :return:
    """
    config = get_config_on_param(path, section, setting, value)

    try:
        config.set(section, setting, value)
    except ConfigError:
        config.add_section(section)
        config.set(section, setting, value)

    with open(path, "wb") as config_file:
        config.write(config_file)


def update_setting(path, section, setting, value):
    """
    Update a setting
    """
    config = get_config(path)
    config.set(section, setting, value)
    with open(path, "wb") as config_file:
        config.write(config_file)


def delete_setting(path, section, setting):
    """
    Delete a setting
    """
    config = get_config(path)
    config.remove_option(section, setting)
    with open(path, "wb") as config_file:
        config.write(config_file)


def crudConfig(path):
    """
    Create, read, update, delete config
    """
    if not os.path.exists(path):
        createDefaultConfig(path)

    config = ConfigParser.ConfigParser()
    config.read(path)

    # read some values from the config
    font = config.get("Settings", "font")
    font_size = config.get("Settings", "font_size")

    # change a value in the config
    config.set("Settings", "font_size", "12")

    # delete a value from the config
    config.remove_option("Settings", "font_style")

    # write changes back to the config file
    with open(path, "wb") as config_file:
        config.write(config_file)


if __name__ == "__main__":
    path = "settings.ini"
    crudConfig(path)
    font = get_setting(path, 'Settings', 'font')
    font_size = get_setting(path, 'Settings', 'font_size')
    update_setting(path, "Settings", "font_size", "12")
    delete_setting(path, "Settings", "font_style")

    configpath = "deployment_history.ini"
    add_setting(configpath, 'E2E1', 'branch', 'R19.7')
    update_setting(configpath, 'E2E1', 'status', 'initial')