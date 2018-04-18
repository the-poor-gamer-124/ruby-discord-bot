module Discord
  module Commands
    extend Discordrb::Commands::CommandContainer

    @admin_roles = [
      171956350438342657,
      414400751574450177
    ]

    desc = "pong!"
    command :ping, description: desc do |event|
      "pong! (#{Time.now - event.timestamp}s)"
    end

    desc  = "Deletes X amount of messages from the channel"
    usage = "#{configatron.discord.bot_prefix}prune <number>"
    command :prune, description: desc, usage: usage, allowed_roles: @admin_roles do |event, amount|
      amount = amount.to_i
      return "You can only delete between 1 and 100 messages!" if amount > 100

      event.channel.prune amount, true
      event.respond "Done pruning #{amount} messages 💥"
    end

    desc  = "Sends a message to the specified channel"
    usage = "#{configatron.discord.bot_prefix}say #channel some message"
    command :say, min_args: 2, description: desc, usage: usage, allowed_roles: @admin_roles do |event, channel, *message|
      channel = channel.gsub("<#", "").to_i
      $bot.send_message channel, message.join(" ")
    end

    desc = "Assigns role to user (You can only assign roles you have)"
    usage = "#{configatron.discord.bot_prefix}role @username @role"
    usage = "#{configatron.discord.bot_prefix}say #channel some message"
    command :role, min_args: 2, max_args: 2, description: desc, usage: usage do |event, mention_user, mention_role|
      member = $bot.parse_mention(mention_user).on event.server
      role   = $bot.parse_mention mention_role

      event.respond "Only <@&414400751574450177> can assign that role 🍆" and break if (mention_role == "<@&426177329312825346>")
      event.respond "You can't assing roles you don't have yourself, fucking idiot 🍆" and break unless (event.user.roles.include? role) || (@admin_roles & event.user.roles.collect(&:id)).any?
      
      member.add_role role
      event.respond "Done! #{mention_user} now has the #{mention_role} role 🎉"
    end

    desc = "Removes role from the user (You can only remove roles you have)"
    usage = "#{configatron.discord.bot_prefix}role @username @role"
    usage = "#{configatron.discord.bot_prefix}say #channel some message"
    command :derole, min_args: 2, max_args: 2, description: desc, usage: usage, allowed_roles: @admin_roles do |event, mention_user, mention_role|
      member = $bot.parse_mention(mention_user).on event.server
      role   = $bot.parse_mention mention_role

      event.respond "Only <@&414400751574450177> can assign that role 🍆" and break if (mention_role == "<@&426177329312825346>")
      event.respond "You can't assing roles you don't have yourself, fucking idiot 🍆" and break unless (event.user.roles.include? role) || (@admin_roles & event.user.roles.collect(&:id)).any?

      member.remove_role role
      event.respond "Done! #{mention_user} doesn't have the #{mention_role} role anymore ☹️"
    end

    # This can be VERY dangerous in the wrong hands. Just allow the owner or very specific people to use it.
    command :eval, help_available: false do |event, *code|
      event.respond "Only the owner can do this" and break unless "#{event.user.id}" == configatron.discord.owner_id

      begin
        eval code.join(' ')
      rescue => e
        "Error 😭: ```#{e}```"
      end
    end

    # Meant to use locally only.
    command :debug, help_available: false do |event, *args|
      return "Nope!" unless configatron.app.env == "development"
      binding.pry
    end
  end
end
