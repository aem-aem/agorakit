import fileinput
import json

for line in fileinput.input():
    line = line.strip()
    _dict = json.loads(line)
    _dict['permissions'] = {'member': ['create-discussion', 'create-file', 'create-action']}
    _dict['custom_permissions'] = True
    new_line = json.dumps(_dict)
    if line != new_line:
        print(f"update groups set settings='{new_line}' where settings='{line.strip()}';")

