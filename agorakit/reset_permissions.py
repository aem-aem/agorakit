import fileinput
import json

for line in fileinput.input():
    line = line.strip().replace('\\\\\"', '\\\\\\\"')
    _dict = json.loads(line)
    _dict['permissions'] = {'member': ['create-discussion', 'create-file', 'create-action']}
    _dict['custom_permissions'] = True
    new_line = json.dumps(_dict).replace('\\\\\\\"', '\\\\\"')
    if line != new_line:
        print(f"update groups set settings='{new_line}' where settings='{line.strip()}';")

