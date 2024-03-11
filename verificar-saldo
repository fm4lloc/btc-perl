#!/usr/bin/perl

use strict;
use warnings;
use Bitcoin::Crypto qw(btc_extprv btc_pub);
use Bitcoin::Crypto::Util qw(generate_mnemonic to_format);
use LWP::UserAgent;
use JSON;

my $balance_threshold = 0.01; # Definir um limite de saldo para considerar uma carteira com saldo suficiente

# Gerar uma frase mnemônica
my $mnemonic = generate_mnemonic();
print "Sua frase mnemônica é: $mnemonic\n";

# Criar uma chave estendida a partir da frase mnemônica
my $master_key = btc_extprv->from_mnemonic($mnemonic);

# Derivar uma chave privada
my $derived_priv_key = $master_key->derive_key_bip44(
    purpose => 44,    # BIP44
    coin => 0,        # Bitcoin
    account => 0,     # Account #0
    change => 0,      # External chain
    index => 0        # Endereço #0
);

# Obter a chave privada básica
my $basic_priv_key = $derived_priv_key->get_basic_key();

# Obter a chave pública correspondente
my $pub_key = $basic_priv_key->get_public_key();

# Exibir a chave privada e pública, bem como o endereço da carteira
print "Chave privada: ", $basic_priv_key->to_wif(), "\n";
print "Chave pública: ", to_format([hex => $pub_key->to_serialized()]), "\n";
print "Endereço da carteira: ", $pub_key->get_address(), "\n";

# Obter saldo da carteira usando a API do blockchain.info
my $wallet_address = $pub_key->get_address();
my $balance = get_wallet_balance($wallet_address);

# Função para obter o saldo da carteira usando a API do blockchain.info
sub get_wallet_balance {
    my ($address) = @_;
    my $url = "https://blockchain.info/rawaddr/$address";
    my $ua = LWP::UserAgent->new;
    $ua->agent(random_user_agent());  # Definir um agente de usuário aleatório
    $ua->timeout(10);  # Definir timeout de 10 segundos
    my $response = $ua->get($url);
    if ($response->is_success) {
        my $data = decode_json($response->decoded_content);
        return $data->{final_balance} / 100000000; # convertendo de satoshis para BTC
    } else {
        print "Erro ao obter saldo: ", $response->status_line, "\n";
        return;
    }
}

# Função para gerar um agente de usuário aleatório
sub random_user_agent {
    my @user_agents = (
        'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
        'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)',
        'Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)',
        'DuckDuckBot/1.0; (+http://duckduckgo.com/duckduckbot.html)'
    );
    return $user_agents[rand @user_agents];
}

# Verificar se o saldo foi obtido com sucesso
if (defined $balance) {
    print "Saldo da carteira: $balance BTC\n";
    # Verificar se o saldo atende ao limite
    if ($balance >= $balance_threshold) {
        print "Carteira encontrada com saldo suficiente!\n";
    } else {
        print "Saldo insuficiente. Tente novamente com outra carteira.\n";
    }
} else {
    print "Erro ao obter saldo. Tentando novamente...\n";
}
