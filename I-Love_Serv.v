import net.http

struct ExampleHandler {}

fn (h ExampleHandler) handle(req http.Request) http.Response {
    url_without_slash := req.url.trim_left('/')
    mut res := http.Response{
        header: http.new_header_from_map({
            http.CommonHeader.content_type: 'text/html'
        })
    }
    
    res.body = '
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WW</title>
    </head>
    <body>
        <h1>Hi, I love ${url_without_slash} !</h1>
    </body>
    </html>
    '
    return res
}


fn main() {
    mut server := http.Server{
        handler: ExampleHandler{}
        // port: 8090
        addr: '127.0.0.1:8090'
    }
    server.listen_and_serve() 
}
