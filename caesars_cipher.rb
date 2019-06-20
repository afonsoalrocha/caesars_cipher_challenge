require 'rubygems'
require 'json'
require 'rickshaw'
require 'HTTParty'

#https://apidock.com/ruby/Net/HTTP

#consumming the codenation's API to get JSON file
get_response = HTTParty.get('https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=ba9c3a40a70664e44aebf97c426159152f93d62a')

#saving the json file in an file called "answer.json"
File.open("answer.json", 'w+') {|file| file.write(get_response.body)}

# parsing the file to use values
file = File.read('answer.json')

challenge = JSON.parse(file)

#decrypting message
decrypted = ""

alphabet = "abcdefghijklmnopqrstuvwxyz"

shift = challenge['numero_casas']

challenge['cifrado'].split('').each { |char| 
    if alphabet.index(char) == nil

        decrypted += char
    else
        char_index = alphabet.index(char)

        new_position = char_index - shift

        decrypted_position = new_position % 26

        decrypted += alphabet[decrypted_position]
    end
}

#saving decrypted JSON into the answer.json file
challenge['decifrado'] = decrypted

solved_challenge = JSON.generate(challenge)

File.open("answer.json", 'w+') {|f| f.write(solved_challenge)}

#generating sha1 summary of the decrypted answer
sha1_summary = challenge['decifrado'].to_sha1

#saving sha1 summary into the answer.json file
challenge['resumo_criptografico'] = sha1_summary

solved_challenge = JSON.generate(challenge)

File.open("answer.json", 'w+') {|f| f.write(solved_challenge)} 

puts challenge