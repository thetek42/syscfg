import yaml

config.load_autoconfig()

with (config.configdir / "config.yml").open() as file:
    yaml_data = yaml.safe_load(file)

def dict_attrs(obj, path=""):
    if isinstance(obj, dict):
        for key, value in obj.items():
            yield from dict_attrs(value, "{}.{}".format(path, key) if path else key)
    else:
        yield path, obj

for key, value in dict_attrs(yaml_data):
    config.set(key, value)

config.set("statusbar.padding", { "bottom": 3, "left": 2, "right": 5, "top": 3 })
config.set("tabs.padding", { "bottom": 3, "left": 5, "right": 5, "top": 3 })
