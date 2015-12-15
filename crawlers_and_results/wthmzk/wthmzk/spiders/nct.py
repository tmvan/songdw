# -*- coding: utf-8 -*-
import scrapy
import json
import re
from wthmzk.items import SongItem

ALLOW_LINK_PATTERN = r"http://www.nhaccuatui\.com/.*\.html"
SONG_LINK_PATTERN = re.compile(r"http://www\.nhaccuatui\.com/bai-hat/.*\.html", re.IGNORECASE)
HIT_COUNTER = "http://www.nhaccuatui.com/interaction/api/v2/hit-counter"

class NctSpider(scrapy.Spider):
    name = "nct"
    allowed_domains = ["nhaccuatui.com"]
    start_urls = (
        'http://www.nhaccuatui.com/',
    )

    def parse(self, response):
        links = response.xpath("//a[@href]/@href").re(ALLOW_LINK_PATTERN)
        for link in links:
            yield scrapy.Request(url=link, callback=self.parse)
            
        if SONG_LINK_PATTERN.match(response.url):
            title = response.xpath('//div[@class="name_title"]/h1[@itemprop="name"]/text()').extract()
            singers = response.xpath('//h2[@class="name-singer"]/a[@href]/text()').extract()
            genres = response.xpath('//div[@class="detail_info_playing_now"]/b[2]/a/text()').extract()
            if title:
                nct_item_id, nct_time, nct_sign, nct_type = \
                    response.xpath("//script[@type=\"text/javascript\"]/text()").re(r"NCTWidget\.hitCounter\('(\d+)', '(\d+)', '(\w+)', \"(\w+)\"\);")
                data = {"item_id": nct_item_id, "time": nct_time, "sign": nct_sign, "type": nct_type}
                parser = self.item_parse(title, singers, genres)
                yield scrapy.FormRequest(url=HIT_COUNTER, method="POST", formdata=data, callback=parser, priority=100)
        
    def item_parse(self, title, singers, genres):
        def ajax_parse(response):
            jdata = json.loads(response.body)
            item = SongItem()
            item["title"] = title[0] if title else ""
            item["singers"] = singers
            item["genres"] = genres
            item["total_play"] = jdata["data"]["counter"]
            return item
        return ajax_parse
            
