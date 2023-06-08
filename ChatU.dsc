ChatU_format:

    type: format

    # The only key is the format. The format can use '<[text]>' as a special def to contain the message being sent.
    # '<[name]>' is available as a special def as well for use with the 'on player chats' event to fill the player's name properly.
    # Note that 'special' means special: these tags behave a little funny in certain circumstances.
    # In particular, these can't be used as real tags in some cases, including for example when using a format script as a determine in the 'player chats' event.
    # | All format scripts MUST have this key!
    format: <[name]>: <[text]>

#ChatU_actions:
#    type: world
#    debug: false
#    events:
#        on player chats:
#            - define prefix <player.chat_prefix>
#            - if <[prefix]> != <empty>:
#                - narrate ok
#                - define prefix <[prefix].replace_text[&r].with[].replace_text[&f].with[<green>].replace_text[&b].with[<dark_green>]>
#            - determine "RAW_FORMAT:<[prefix]><dark_green><player.name>: <green><context.message>"
            #- narrate <green><context.message>
            #- narrate <green><context.format>
            #- narrate <green><context.full_text>
            #- narrate <green><context.recipients>