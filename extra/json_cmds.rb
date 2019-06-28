# Copyright Erisa Komuro (Seriel), spotlight_is_ok, Larsenv 2017
module YuukiBot
  module Extra
    if YuukiBot.config['extra_commands']
      json_food_commands = %w(beer biscuit brekkie burger cake cereal cheese chicken chocolate coffee cookie donut doobie drinks halal icecream kebab keto kosher milkshake muffin noodles nugget oreo pancake pasta pie pizza potato rice sandwich scone snack soup steak sushi taco tea wine)

      json_food_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event,args|
            target = begin
              event.bot.parse_mention(args.join(' ')).name
            rescue
              args.join(' ')
            end
            json = JSON.parse(File.read("text/Food/#{x}.json"))

            variables = {}
            variables['user'] = target
            event.respond("*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
          },
          triggers: [x, "give #{x} to ",  "give a #{x} to "]
        )
        puts "Added food command for #{x}!" if YuukiBot.config['verbose']
      }
      $cbot.commands[:brekkie][:triggers].push('breakfast', 'brekky', 'give breakfast to ', 'give a breakfast to', 'give brekky to ', 'give a brekky to')

      json_attack_commands = %w(slap compliment strax present)
      json_attack_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event,args|
            target = begin
              event.bot.parse_mention(args.join(' ')).name
            rescue
              args.join(' ')
            end
            json = JSON.parse(File.read("text/Attack/JSON/#{x}.json"))

            variables = {}
            variables['user'] = target
            event.respond("*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
          }
        )
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      }

      text_attack_commands = %w(lart insult)
      text_attack_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event,args|
            target = begin
              event.bot.parse_mention(args.join(' ')).name
            rescue
              args.join(' ')
            end
            result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
            result = result.gsub('{user}', target) if /{user}/ =~ result

            event.respond("*#{result}*")
          }
        )
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      }

      text_attack_commands = %w(nk)
      text_attack_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event|
            result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp

            event.respond("*#{result}*")
          }
        )
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      }

      text_joke_commands = %w(doit pun wisdom lawyerjoke)
      text_joke_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event|
            result = File.readlines("text/Jokes/#{x}.txt").sample.chomp

            event.respond("*#{result}*")
          }
        )
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      }

      text_other_commands = %w(vote topicchange fortunes factdiscord randomssmash4item)
      text_other_commands.each { |x|
        $cbot.add_command(x.to_sym,
          code: proc { |event|
            result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp

            event.respond("*#{result}*")
          }
        )
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      }

      $cbot.add_command(:randomquestion,
        code: proc { |event|
          json = JSON.parse(File.read('text/Other/JSON/randomquestion.json'))

          # prng = Random.new
          variables = {}
          response = Textgen.generate_string(json['templates'], json['parts'], variables)

          event.respond(response)
        }
      )
      puts 'Added fun command for random question!' if YuukiBot.config['verbose']


      $cbot.add_command(:nextzeldagame,
        code: proc { |event|
          json = JSON.parse(File.read('text/Other/JSON/nextzeldagame.json'))

          prng = Random.new
          variables = {}
          variables['random_number'] = prng.rand(1..10)
          response = Textgen.generate_string(json['templates'], json['parts'], variables)

          event.respond(response)
        }
      )
      puts 'Added fun command for nextzeldagame!' if YuukiBot.config['verbose']

      $cbot.add_command(:confucious,
        code: proc { |event, _|
          event.respond("Confucious say #{File.readlines('text/Jokes/confucious.txt').sample.chomp}")
        }
      )
      puts 'Added jokes command for confucious!' if YuukiBot.config['verbose']

      $cbot.add_command(:bookpun,
        code: proc { |event, _|
          title, author = File.readlines('text/Jokes/bookpun.txt').sample.chomp.split ': ', 2
          event.respond("#{title} by #{author}")
        }
      )
      puts 'Added jokes command for bookpun!' if YuukiBot.config['verbose']

      $cbot.add_command(:wouldyourather,
        code: proc { |event, _|
          json_string = open('http://rrrather.com/botapi').read
          array = JSON.parse(json_string, symbolize_names: true)
          event.respond("#{array[:title]}: #{array[:choicea].rstrip} OR #{array[:choiceb].rstrip}")
        }
      )
      puts 'Added fun command for wouldyourather!' if YuukiBot.config['verbose']

      $cbot.add_command(:fact,
        code: proc { |_, _|
          types = %w(trivia math date year)
          type = types.sample
          open("http://numbersapi.com/random/#{type}").read
        }
      )
      puts 'Added fun command for fact!' if YuukiBot.config['verbose']

      $cbot.add_command(:eightball,
        code: proc { |event, _|
          event.respond("shakes the magic 8 ball... **#{File.readlines('text/Other/8ball_responses.txt').sample.chomp}**")
        }
      )
      puts 'Added fun command for eightball!' if YuukiBot.config['verbose']
    #end

      $cbot.add_command(:cats,
        code: proc { |event, _|
          json_string = open('https://catfacts-api.appspot.com/api/facts').read
          array = JSON.parse(json_string, symbolize_names: true)
          event.respond(array[:facts][0].to_s)
        }
      )
      puts 'Added fun command for cats!' if YuukiBot.config['verbose']

      $cbot.add_command(:catgifs,
        code: proc { |event, _|
          gif_url = nil
          open('http://marume.herokuapp.com/random.gif') do |resp|
          gif_url = resp.base_uri.to_s
          end
          event.respond("OMG A CAT GIF: #{gif_url}")
        }
      )
      puts 'Added fun command for catgifs!' if YuukiBot.config['verbose']

=begin
      $cbot.add_command(:flip,
        code: proc { |event,args|
          args = args.join(' ')
          begin
          target = event.bot.parse_mention(args).on(event.server).display_name.name
          rescue
          target = args
          end
          flippers = ['( ﾉ⊙︵⊙）ﾉ', '(╯°□°）╯', '( ﾉ♉︵♉ ）ﾉ']
          flipper = flippers.sample
          event.respond("#{flipper}  ︵ #{target.flip}")
        },
      }
      puts "Added fun command for flip!" if YuukiBot.config['verbose']
=end

      $cbot.add_command(:fight,
        code: proc { |event,args|
          args = args.join(' ')
          begin
          target = event.bot.parse_mention(args).name
          rescue
          target = args
          end
          json = JSON.parse(File.read('text/Attacks/JSON/fight.json'))

          variables = {}
          variables['user'] = event.user.name
          variables['target'] = target
          response = Textgen.generate_string(json['templates'], json['parts'], variables)

          event.respond(response)
        }
      )
      puts 'Added fun command for fight!' if YuukiBot.config['verbose']

      $cbot.add_command(:love,
        code: proc { |event,args|
            first = ''
            second = ''
            if args.length == 1
              first = event.user.name
              begin
                second = event.bot.parse_mention(args).name
              rescue
                second = args[0]
              end
            elsif args.length == 2
              first = args[0]
              second = args[1]
            end

          prng = Random.new
            percentage = prng.rand(1..100)

          case
          when percentage < 10
            result = 'Awful 😭'
          when percentage < 20
            result = 'Bad 😢'
          when percentage < 30
            result = 'Pretty Low 😦'
          when percentage < 40
            result = 'Not Too Great 😕'
          when percentage < 50
            result = 'Worse Than Average 😐'
          when percentage < 60
            result = 'Barely 😶'
          when percentage == 69
            result = '( ͡° ͜ʖ ͡°)'
          when percentage < 70
           result = 'Not Bad 🙂'
          when percentage < 80
            result = 'Pretty Good 😃'
          when percentage < 90
            result = 'Great 😄'
          when percentage < 100
            result = 'Amazing 😍'
          when percentage == 100
            result = 'PERFECT! :heart_exclamation:'
          else
            result = 'Error!'
          end

          response = "💗 **MATCHMAKING** 💗\n" +
          "First - #{first}\n" +
          "Second - #{second}\n" +
          "**-=-=-=-=-=-=-=-=-=-=-=-**\n" +
          "Result ~ #{percentage}% - #{result}\n"

          event.respond(response)
        },
        triggers: ['love', 'ship ']
      )
      puts 'Added fun command for love!' if YuukiBot.config['verbose']
=begin
      $cbot.add_command(:randommovie,
        code: proc { |event, _|
          movie = open('https://random-movie.herokuapp.com/random').read
          array = JSON.parse(movie, symbolize_names: true)

          response = ":film_frames: **Random Movie** :film_frames:\n" +
          "Title: #{array[:Title]}\n" +
          "Year: #{array[:Year]}\n" +
          "Rating: #{array[:Rated]}\n" +
          "Runtime: #{array[:Runtime]}\n" +
          "Plot: #{array[:Plot]}\n" +
          "IMDB Rating: #{array[:imdbRating]}\n" +
          "IMDB Votes: #{array[:imdbVotes]}\n" +
          "Poster: #{array[:Poster].sub('._V1_SX300', '')}"

          event.respond(response)

        }
      )
=end
      puts 'Added fun command for randommovie!' if YuukiBot.config['verbose']
    end
	$cbot.add_command(:choose,
		code: proc { |event,args|
			event.respond("I choose #{args.sample}!")
    }
  )

  end
end
