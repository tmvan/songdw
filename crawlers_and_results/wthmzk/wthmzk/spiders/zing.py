# -*- coding: utf-8 -*-
import scrapy
import json
import re
from wthmzk.items import SongItem

ALLOW_LINK_PATTERN = r"http://mp3\.zing\.vn/.*\.html"
SONG_LINK_PATTERN = re.compile(r"(http://)?mp3\.zing\.vn/bai-hat/[^/]+/([a-z0-9]+)\.html", re.IGNORECASE)
HIT_COUNTER = "http://mp3.zing.vn/xhr/song/get-total-play?id=%s&type=song"
INFO_CONTENT = "body > div.wrap-body.group.page-play-song.container > div.wrap-content > div.info-top-play.group > div.info-content *::text"

class ZingSpider(scrapy.Spider):
    name = "zing"
    allowed_domains = ["mp3.zing.vn"]
    start_urls = (
        'http://www.mp3.zing.vn/',
    )

    def parse(self, response):
        links = response.xpath("//a[@href]/@href").re(ALLOW_LINK_PATTERN)
        for link in links:
            yield scrapy.Request(url=link, callback=self.parse)

        match = SONG_LINK_PATTERN.match(response.url)
        if match:
            info = response.css(INFO_CONTENT).extract()
            clean = [text for text in [ugly.strip() for ugly in info] if text != '']
            indices = [i for i in range(len(clean)) if clean[i].find(u'Th\u1ec3 lo\u1ea1i:') != -1]
            title = clean[0]
            singers = [] if clean[1] != '-' else [clean[2], clean[4]] if clean[3] == 'ft.' else [clean[2]]
            genres = [genre for genre in clean[indices[0]+1:] if genre != ','] if indices else []
            hit_counter_url = HIT_COUNTER % match.group(2)
            func = self.item_parse(title, singers, genres)
            yield scrapy.Request(url=hit_counter_url, callback=func, priority=100)
            
        
    def item_parse(self, title, singers, genres):
        def ajax_parse(response):
            jdata = json.loads(response.body)
            item = SongItem()
            item["title"] = title
            item["singers"] = singers
            item["genres"] = genres
            item["total_play"] = jdata["total_play"]
            return item
        return ajax_parse
