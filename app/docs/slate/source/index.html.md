---
title: API Reference

language_tabs:
  - ruby

toc_footers:
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - users
  - subscriptions
  - errors

search: true
---

# Introduction

### API 文档

 - 没有特别标出 HTTP Status Code 的就是 200

 - 如果在调用 API 时发现了文档中没有写出的错误，可能是因为触犯了某些广泛使用的机制比如身份验证不通过导致 401。由于重复次数过多所以没有在每个 API 中写明，请在左侧 Errors 一栏中寻找。

# Authentication

## token

```bash
curl "http://localhost:3000/api/v1/auth/token?\
email=maki@otanashisaka.com&\
password=Nishikino"
```

> The response will be shown as this:

```ruby
4951769622a4a991bb2d515ed12cc9c0
```

API 调用时的身份认证。
最长 30 天过期一次。

### HTTP Request

`GET /api/v1/auth/token`

### Query Parameters

Parameter | Optionality | Data Type | Description
--------- | ----------- | --------- | ------------
email     | required    | string    | user email
password  | required    | string    | password

### Errors

Error Code | Message | Meaning
---------- | ------- | -------
400 | Please provide your email and password to verify your identity | 缺少 email / password 其中一个
401 | Unauthorized to access | 邮箱和密码不匹配


