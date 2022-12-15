# A Gema Ruby do Twitter

[![Versão Gem](https://badge.fury.io/rb/twitter.svg)][gem]
[![Estado de Construção](https://travis-ci.org/sferik/twitter.svg?branch=master)][travis]
[![Manutenibilidade](https://api.codeclimate.com/v1/badges/09362621ad91e8f599b3/maintainability)][manutenibilidade]
[![Estatuto da Cobertura](https://coveralls.io/repos/github/sferik/twitter/badge.svg?branch=master)][macacão][macacão
[![Documentos em linha](http://inch-ci.org/github/sferik/twitter.svg?style=shields)][páginas de polegada]

[gema]: https://rubygems.org/gems/twitter
[travis]: https://travis-ci.org/sferik/twitter
[mantenibilidade]: https://codeclimate.com/github/sferik/twitter/maintainability
[fato-macaco]: https://coveralls.io/r/sferik/twitter
[páginas em polegadas]: http://inch-ci.org/github/sferik/twitter

Uma interface Ruby para a API do Twitter.

## Instalação
    gem instalar twitter

## CLI
Procura a interface de linha de comando do Twitter? Foi [removido][] desta
gema na versão 0.5.0 e agora existe como um [projecto separado][t].

[removed]: https://github.com/sferik/twitter/commit/dd2445e3e2c97f38b28a3f32ea902536b3897adf
[t]: https://github.com/sferik/t

## Documentação
[http://rdoc.info/gems/twitter][documentação]

[documentação]: http://rdoc.info/gems/twitter

## Exemplos
[https://github.com/sferik/twitter/tree/master/examples][exemplos] [exemplos

[exemplos]: https://github.com/sferik/twitter/tree/master/examples

## Anúncios
Deve [seguir @gem][seguir] no Twitter para anúncios e actualizações sobre
esta biblioteca.

[seguir]: https://twitter.com/gem

## Mailing List
Por favor, dirija perguntas sobre esta biblioteca para a [mailing list].

[lista de correio]: https://groups.google.com/group/twitter-ruby-gem

## Apps Wiki
O seu projecto ou organização utiliza esta jóia? Adicione-a às [aplicações
wiki][aplicações]!

[aplicações]: https://github.com/sferik/twitter/wiki/apps

## Configuração
O Twitter API v1.1 requer que se autentique via OAuth, pelo que necessitará de
[registe a sua candidatura no Twitter][registe-se]. Depois de registar um
de acesso, certifique-se de definir o nível de acesso correcto, caso contrário poderá ver
o erro:

[registar]: https://apps.twitter.com/

    A aplicação só de leitura não pode POST

A sua nova aplicação receberá um par chave/secreto de consumidor e
ser-lhe-á atribuído um par simbólico/secreto de acesso OAuth para essa aplicação. Vai precisar de
para configurar estes valores antes de fazer um pedido ou então receberá o
erro:

    Dados de má autenticação

Pode passar as opções de configuração como um bloco para `Twitter::REST::Client.new`.

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key = "YOUR_CONSUMER_KEY" (O SEU_CONSUMIDOR_KEY)
  config.consumer_secret = "YOUR_CONSUMER_SECRET" (SUA_CONSUMIDOR_SECRET)
  config.access_token = "YOUR_ACCESS_TOKEN" (O SEU_ACESSO_TOKEN)
  config.access_token_secret = "YOUR_ACCESS_SECRET"
fim
```

## Exemplos de utilização
Depois de configurar um `cliente`, pode fazer as seguintes coisas.

**Tweet (como o utilizador autenticado)**

```ruby
client.update("Estou a tweetar com @gem!")
```
**Seguir um utilizador (por nome de ecrã ou ID de utilizador)**

```ruby
client.follow("gema")
client.follow(213747670)
```
**Passar um utilizador (por nome de ecrã ou ID de utilizador)**

```ruby
client.user("gema")
client.user(213747670)
```
**Vai buscar uma lista maldita de seguidores com detalhes do perfil (por nome de ecrã ou ID de utilizador, ou por utilizador autenticado implícito)**

```ruby
client.followers("gema")
client.followers(213747670)
client.followers
```
**Vai buscar uma lista maldita de amigos com detalhes do perfil (por nome de ecrã ou ID de utilizador, ou por utilizador autenticado implícito)**

```ruby
client.friends("gema")
client.friends(213747670)
client.friends
```

**Apanhar a linha temporal de Tweets por um utilizador***

```ruby
client.user_timeline("gema")
client.user_timeline(213747670)
```
**Vá buscar a linha temporal de Tweets à página inicial do utilizador autenticado***

```ruby
client.home_timeline
```
**Vá buscar a linha temporal de Tweets mencionando o utilizador autenticado***

```ruby
client.mentions_timeline
```
**Vai buscar um Tweet específico por ID***

```ruby
client.status(27558893223)
```
**Recolher as três propostas de casamento mais recentes a @justinbieber***

```ruby
client.search("to:justinbieber casar comigo", resultado_tipo: "recente").take(3).collect do |tweet|
  "#{tweet.user.screen_name}: #{tweet.text}"
fim
```
**Localização de um Tweet em japonês #ruby (excluindo retweets)**

```ruby
client.search("#ruby -rt", lang: "ja").first.text
```
Para mais exemplos de utilização, consulte a [documentação][] completa.

## Streaming
Os Site Streams estão restritos a contas listadas a branco. Para solicitar o acesso,
[siga os passos na documentação do Site Streams][site-streams]. [Utilizador
Streams][fluxos de utilizadores] não requerem aprovação prévia.

[site-streams]: https://dev.twitter.com/streaming/sitestreams#applyingforaccess
[user-streams]: https://dev.twitter.com/streaming/userstreams

**Configuração funciona tal como `Twitter::REST::Client`**

```ruby
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key = "YOUR_CONSUMER_KEY" (O SEU_CONSUMIDOR_KEY)
  config.consumer_secret = "YOUR_CONSUMER_SECRET" (SUA_CONSUMIDOR_SECRET)
  config.access_token = "YOUR_ACCES

Traduzido com a versão gratuita do tradutor - www.DeepL.com/Translator