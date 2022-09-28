# httpd-mock

A very simple httpd server for debugging.
* mocking web server
* checking request parameters

## Usage

```console
$ httpd-mock :8080
Listening on http://0.0.0.0:8080
```

```console
$ curl localhost:8080
```

```
=== 2022-09-28 12:54:38 +09:00 ======================
GET / HTTP/1.1
Host: localhost:8080
User-Agent: curl/7.81.0
Accept: */*
--- body ----------------------
```

For more information, see [src/httpd-mock.cr](./src/httpd-mock.cr). It's just under 100 lines.

## Development

* requires **crystal**

```console
$ make
```

## Contributing

1. Fork it (<https://github.com/maiha/httpd-mock/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) - creator and maintainer
