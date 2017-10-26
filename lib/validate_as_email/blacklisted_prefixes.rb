# frozen_string_literal: true

module ValidateAsEmail
  module BlacklistedPrefixes
    def self.list
      %w(
        abuse
        admin
        administrator
        anon
        arse
        arsehole
        ass
        asshole
        bastard
        billing
        bin
        bitch
        blacklist
        blacklisted
        blacklister
        blacklisting
        blacklists
        blowjob
        bogus
        bullshit
        ceo
        cfo
        cock
        coo
        cto
        cunt
        customer
        default
        delete
        dick
        dickhead
        dnsadmin
        dnsmaster
        douche
        douchebag
        dsnadmin
        email
        fbl
        feedback
        foo
        ftp
        fuck
        fucker
        fuckhead
        fuckwit
        garbage
        hate
        help
        hijodeputa
        hostmaster
        info
        invalid
        ipadmin
        junk
        junkman
        list
        lovesick
        lovesickness
        mail
        mailer-daemon
        marketing
        motherfucker
        news
        newsletter
        nobody
        noc
        none
        nowhere
        null
        ops
        orders
        penis
        piss
        poo
        poop
        postmaster
        press
        privacy
        pussy
        remove
        root
        sales
        scam
        security
        shit
        shitass
        shithead
        shithouse
        sluts
        spam
        ssladmin
        staff
        subscribe
        suck
        suckhole
        support
        sys
        team
        tits
        trash
        usenet
        vagina
        vulgarities
        webmaster
        whore
        www
      ).freeze
    end
  end
end