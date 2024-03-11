#!/usr/bin/perl

use strict;
use warnings;
use Bitcoin::Crypto qw(btc_extprv btc_pub);
use Bitcoin::Crypto::Util qw(generate_mnemonic to_format);

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
