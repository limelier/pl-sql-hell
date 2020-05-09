import xml.etree.ElementTree as ET

root = ET.parse('../../psgbd-db/student/catalog.xml').getroot()

for tag in root.findall('entry'):
    print('{} {} | {} | {}'.format(tag.get('name'), tag.get('surname'), tag.get('course'), tag.get('value'), tag.get('date')))
