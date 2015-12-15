import os
from datetime import datetime

now = datetime.now()
str_today = str(now.year) + str(now.month) + str(now.day)
cmd = 'start cmd /k "cd wthmzk & scrapy crawl %(bot)s -o %(file)s"'
result_dir = "__crawl_results"

path = os.path.join("..", result_dir)
file1 = os.path.join(path, str_today + "nct.csv")
file2 = os.path.join(path, str_today + "zing.csv")

os.system(cmd % {"bot": "nct", "file": file1})
os.system(cmd % {"bot": "zing", "file": file2})
