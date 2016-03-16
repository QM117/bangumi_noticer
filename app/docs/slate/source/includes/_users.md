# Users

## create

```bash
curl -X POST "http://localhost:3000/api/v1/users"\
-d name=kotori \
-d email=kotori@otonashisaka.com \
-d password=minami
```

> The above command returns JSON structured like this:

```ruby
HTTP Status Code: 201
{
    "user":
    {
        "id":8,
        "name":"kotori",
        "email":"kotori@otonashisaka.com",
        "last_viewed_at":"2016-03-15T12:30:40.171Z"
    }
}
```

给出用户数据，创建新用户

### HTTP Request

`POST /api/v1/users`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
name      |  required   | string    | user name
email     |  required   | string    | 邮箱，用于登录和通知，唯一
password  |  required   | string    | password
password_confirmation | optional | string | 确认密码，如果给出这个参数后台会验证与 password 是否相等。不给就以 password 为准。

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400 | Bad request! Some parameters is missing or invalid. | email / name / password 之一的参数缺少
500 | There is an error in saving a user | password_confirmation 不匹配，或者其他服务器内部错误。内部错误请联系管理员。



## show


```bash
curl "http://localhost:3000/api/v1/users/1?\
token=6bb96bc489b9b11cdca1a3edba1f1944"
```

> The command above returns...

```ruby
{
    "user":
    {
        "id":1,
        "name":"maki",
        "email":"maki@otonashisaka.com",
        "last_viewed_at":"2000-01-01T00:00:00.000Z"
    }
}
```

以用户 id 获取用户相关的详细内容。需要 token.
会检查权限，权限不符合会被拒绝。
目前权限设定是只能查看自己的信息。

### HTTP Request

`GET /api/v1/users/:id`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
token     | required    | string    | access token
id (path)  | required    | integer   | user id

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400 | Bad request! Some parameters is missing or invalid. | 参数 id 缺失
404 | User not found by this id. | 找不到此 id 对应的 user
401 | You are not authorized to access the resource | 当前用户 (token) 没有权限访问此 id 用户的信息



## subscribe


```bash
curl -X PUT "http://localhost:3000/api/v1/users/subscribe" \
-d token=18a9a20ba8ad67513bcec11a5d7d1639 \
-d subscription_id=1
```

> And the response is...

```ruby
{
    "message":"ok"
}
```

当前用户关联指定的订阅规则

### HTTP Request

`PUT /api/v1/users/subscribe`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
token     | required    | string    | access token
subscripton_id | required | integer | subscription id

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400 | Bad request! Some parameters is missing or invalid | 参数 subscription_id 缺失
404 | Subscription not found by this id | 无此 id 对应的 subscription 资源

## unsubscribe

```bash
curl -X PUT "http://localhost:3000/api/v1/users/unsubscribe" \
-d token=18a9a20ba8ad67513bcec11a5d7d1639 \
-d subscription_id=1
```

> Response...

```ruby
{
    "message":"ok"
}
```

当前用户取消关联指定的订阅规则

### HTTP Request

`PUT /api/v1/users/unsubscribe`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
token     | required    | string    | access token
subscripton_id | required | integer | subscription id

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400 | Bad request! Some parameters is missing or invalid | 参数 subscription_id 缺失
404 | Subscription not found by this id | 无此 id 对应的 subscription 资源
