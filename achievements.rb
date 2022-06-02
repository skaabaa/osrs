require 'net/http'
require 'csv'

requirements = {
	agility: 91, attack:50, cooking: 95, crafting: 85,
	construction: 78, defence: 70,  farming: 91, firemaking: 85,
	fishing: 96, fletching: 95, herblore: 90, hunter: 70,
	magic: 96, mining: 85, prayer: 85, runecraft: 91,
	slayer: 95, smithing: 91, strength: 76, ranged: 70,
	thieving: 91, woodcutting: 90
	}
	

possible_skills = %w[agility attack cooking crafting construction defence farming
	    firemaking fishing fletching herblore hunter
	    magic mining prayer runecraft
	    slayer smithing strength ranged thieving wooductting]
	    
all_skills = %w[attack defence strength hitpoints ranged prayer magic cooking
				woodcutting fletching fishing firemaking crafting smithing
				mining herblore agility thieving slayer farming runecraft 
				hunter construction]
	    
puts "Please input character name"
	    
player = gets.chomp.downcase

uri = URI("https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{player}")
res = Net::HTTP.get_response(uri)

skill_levels = []
hiscores = CSV.parse(res.body).flatten
hiscores.each do |s|
	skill_levels << s if s.length == 2
end

skill_hash = Hash[all_skills.zip(skill_levels)]
skill_hash = skill_hash.transform_values(&:to_i)


validity_check = false

while !validity_check do
  skill_selector = rand(requirements.size)
  next_skill = possible_skills[skill_selector]
  redo if requirements[next_skill.to_sym] < skill_hash[next_skill.to_s]
  validity_check = true
end

skill_level = requirements[next_skill.to_sym]
current_skill_level = skill_hash[next_skill.to_s]
next_skill_level = rand((current_skill_level + 10)..skill_level)

next_skill_level = (current_skill_level + 10) > skill_level ? skill_level : next_skill_level

	    
puts "Selecting your next grind!"
sleep(4)
puts "Your next goal is #{next_skill_level} #{next_skill}!"
