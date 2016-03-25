# Bangumis

## unread

```bash
curl "http://localhost:3000/api/v1/subscriptions/ \
token=22a7f88de19ef382043628e44a45c3d3"
```

> The response will show you some mystrious code!

```ruby
{
    "bangumis":
    [
        {
            "id":1260,
            "title":"灰と幻想のグリムガル Hai to Gensou no Grimgar - 02.5 (OVA) (BD 1280x720 x264 AAC).mp4",
            "upload_at":"2016-03-24T04:23:00.000Z",
            "fansub":null,
            "size":"225.4MB",
            "magnet_link":"magnet:?xt=urn:btih:L2KOOMRXZC66BOT3J4B65V2AKSA3ONFX",
            "viewed":false
        }
    ]
}
```

核心功能，获取当前用户最近订阅的所有番组 (bangumis), 按照上传时间倒叙排列。  
默认情况下，给出的是最近一周内订阅的所有番组，数量限制为 20 条。时间区间和数量可以通过参数指定。  
另外给出参数 viewed 表示这一话当前用户是否看过。
每个用户会记录最后一次调用这个 API 的时间 (last_viewed_at),
viewed 就是通过比较 user.last_viewed_at 和 番组 (bangumi) 的创建时间来判断已读未读。  

### HTTP Request

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
token     | required    | string    | user access token
from_date | optional    | datetime  | 指定时间区间。不提供表示 7 天前。
to_date   | optional    | datetime  | 指定时间区间。不提供表示当前时间。
limit     | optional    | integer   | Limit of amount. Default value is 20.

### Error Code

Error Code | Message | Meaning
---------- | ------- | -------
400        | Bad request! The parameter 'from_date' or 'to_date' is invalid. | 解析日期时出现错误
