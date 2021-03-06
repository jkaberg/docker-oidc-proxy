local opts = {
    redirect_uri_path = os.getenv("OID_REDIRECT_PATH") or "/redirect_uri",
    discovery = os.getenv("OID_DISCOVERY"),
    client_id = os.getenv("OID_CLIENT_ID"),
    client_secret = os.getenv("OID_CLIENT_SECRET"),
    token_endpoint_auth_method = os.getenv("OIDC_AUTH_METHOD") or "client_secret_basic",
    scope = os.getenv("OIDC_AUTH_SCOPE") or "openid",
    iat_slack = 600,
}

-- call authenticate for OpenID Connect user authentication
local res, err, _target, session = require("resty.openidc").authenticate(opts)

ngx.log(ngx.DEBUG, tostring(res))
ngx.log(ngx.DEBUG, tostring(err))

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

ngx.log(ngx.DEBUG, "Authentication successful, setting Auth header...")
ngx.req.set_header("Authorization", "Bearer "..session.data.enc_id_token)
ngx.log(ngx.DEBUG, "Authentication successful, proxy passing...")
