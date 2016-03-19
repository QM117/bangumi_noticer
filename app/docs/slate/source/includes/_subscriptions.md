# Subscriptions

## create

```bash
curl -X POST "http://localhost:3000/api/v1/subscriptions/" \
-d token=8e7c69261918bf7d088b7023b59b57aa \
-d name='One Punch Man' \
-d rule='punch'
```

> Response of the command above like this:

```ruby
HTTP Status Code: 201
{
    "subscription":
    {
        "id":1,
        "name":"One Punch Man",
        "rule":"punch"
    }
}
```

创建一个新的订阅规则 (subscription).
需要登录，但不会自动关联到当前用户。

### HTTP Request

`POST /api/v1/subscriptions/`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
token     | required    | string    | access token
name      | required    | string    | subscription name
rule      | required    | string    | 用于匹配番组 (bangumi) 标题 (title) 的正则表达式。当然也可以直接当作搜索关键字来使用。

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400        | Bad request! parameter 'name' or 'rule' is missing | 缺少 name / rule 其中之一
500        | This is an error in saveing a subscribe rule | 服务器内部错误，发现请联系管理员



## show

```bash
curl "http://localhost:3000/api/v1/subscriptions/1?\
token=d76ea6b03366edd884e6bca89f3689f2"
```

> And the response ....

```ruby
{
    "subscription":
    {
        "id":1,
        "name":"Luck and Logic",
        "rule":"Logic"
    }
}
```

Show the details of a subscription

### HTTP Request

`GET /api/v1/subscriptions/:id`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
id (path) | required    | integer   | subscription id
token     | required    | string    | access token

### Error Code

Error Code | Message | Meaning
---------- | ------- | -------
404        | Subscription not found! | 无此 id 对应的 subscription 资源



## update

```bash
curl -X PUT "http://localhost:3000/api/v1/subscriptions/1" \
-d token=a58ab9e270467c511af98e68a6b19736 \
-d rule=Luck
```

> After that, the response will be shown as:

```ruby
{
    "message":"ok"
}
```

Update a specific subscription

### HTTP Request

`PUT /api/v1/subscription/:id`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | -----------
id (path) | required    | integer   | subscription id
token     | required    | string    | access token
name      | optional    | string    | subscription name
rule      | optional    | string    | subscription rule, regular expression

### Error Code

Error Code | Message | Meaning
---------- | ------- | -------
404        | Subscription not found! | 无此 id 对应的 subscription 资源
