																																																																																																																						
local WHITE = "|cffffffff"
local SILVER = "|cffc0c0c0"
local GREEN = "|cff00ff00"
local LTBLUE = "|cffa0a0ff"
function DIYCE_DebugSkills(skillList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Skill List:")
    
    for i,v in ipairs(skillList) do
        DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..i..SILVER.."]: "..LTBLUE.."\" "..WHITE..v.name..LTBLUE.."\"  use = "..WHITE..(v.use and "true" or "false"))
    end
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")
end
function DIYCE_DebugBuffList(buffList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Buff List:")
    
    for k,v in pairs(buffList) do
        -- We ignore numbered entries because both the ID and name 
        -- are stored in the list. This avoids doubling the output.
        if type(k) ~= "number" then
            DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..k..SILVER.."]:  "..LTBLUE.."id: "..WHITE..v.id..LTBLUE.."  stack: "..WHITE..v.stack..LTBLUE.."  time: "..WHITE..v.time)
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")    
end
local silenceList = {
  ["Annihilation"]  = true,
  ["King Bug Shock"]  = true,
  ["Mana Rift"]   = true,
  ["Dream of Gold"]  = true,
  ["Flame"]    = true,
  ["Flame Spell"]  = true,
  ["Wave Bomb"]   = true,
  ["Silence"]   = true,
  ["Recover"]   = true,
  ["Restore Life"]  = true,
  ["Heal"]    = true,
  ["Curing Shot"]  = true,
  ["Leaves of Fire"]  = true,
  ["Urgent Heal"]  = true,
  ["Merging Rune"]  = true, --Jacklin Sardo
  ["Heavy Shelling"]  = true, --Juggler Apprentice in Grafu
  ["Dark Healing"]    = true, --Mini-boss in Sardo
     }
function KillSequence(arg1, goat2, healthpot, manapot, foodslot)

--arg1 = "v1" or "v2"for debugging
--healthpot = # of actionbar slot for health potions
--manapot = # of actionbar slot for mana potions
--foodslot = # of actionbar slot for food (add more args for more foodslots if needed)
    local Skill = {}
    local Skill2 = {}
    local i = 0
    
    -- Player and target status.
    local combat = GetPlayerCombatState()
    local enemy = UnitCanAttack("player","target")
    local EnergyBar1 = UnitMana("player")
    local EnergyBar2 = UnitSkill("player")
    local pctEB1 = PctM("player")
    local pctEB2 = PctS("player")
    local tbuffs = BuffList("target")
    local pbuffs = BuffList("player")
    local tDead = UnitIsDeadOrGhost("target")
    local behind = (not UnitIsUnit("player", "targettarget"))
    local melee = GetActionUsable(61) -- # is your melee range spell slot number
    local a1,a2,a3,a4,a5,ASon = GetActionInfo(14)  -- # is your Autoshot slot number
    local phealth = PctH("player")
    local thealth = PctH("target")
    local LockedOn = UnitExists("target")
    local boss = UnitSex("target") > 2
    local elite = UnitSex("target") == 2
    local party = GetNumPartyMembers() >= 2
    
    
    --Determine Class-Combo
    mainClass, subClass = UnitClassToken( "player" )
    --Silence Logic
    local tSpell,tTime,tElapsed = UnitCastingTime("target")
    local silenceThis = tSpell and silenceList[tSpell] and ((tTime - tElapsed) > 0.1)
    
    --Potion Checks
    healthpot = healthpot or 0
    manapot = manapot or 0
    
    --Equipment and Pet Protection
    if phealth <= .02 then
            SwapEquipmentItem()        --Note: Remove the first double dash to re-enable equipment protection.
        for i=1,6 do
            if (IsPetSummoned(i) == true) then
                ReturnPet(i);
            end
        end        
    end


--Begin Player Skill Sequences
    
        --Priest = AUGUR, Druid = DRUID, Mage = MAGE, Knight = KNIGHT, 
        --Scout = RANGER, Rogue = THIEF, Warden = WARDEN, Warrior = WARRIOR

-- Class: Warrior/Warden
            if mainClass == "WARRIOR" and subClass == "WARDEN" then
   --Timers for this class
 CreateDIYCETimer("SSBleed", 6.5) 
 --Change the value between 6 -> 7.5 depending on your lag.
 --Potions and Buffs
Skill = {
{ name = "Instynkt Przetrwania",      use = (phealth <= .49) },
{ name = "Amulet Elfów",       use = (EnergyBar2 >= 150) and (phealth <= .35) },
}
--Combat
if enemy then
Skill = { 
--{ name = "Przebudzenie Dzikości",      use = (tbuffs[501502]) },
{ name = "Wybuchowy Cyklon",      use = (tbuffs[502112]) and (EnergyBar2 >= 35) },
{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
{ name = "Dziki Wir",      use = (EnergyBar2 >= 470) },
{ name = "Odsłonięta Flanka",      use = (EnergyBar1 >= 10) and (tbuffs[501502]) },
{ name = "Atak Taktyczny",      use = ((tbuffs[500081]) and (EnergyBar1 >= 15)) },
{ name = "Próbny Atak",      use = (EnergyBar1 >= 20) },
{ name = "Cięcie",      use = (EnergyBar1 >= 25), timer = "SSBleed", ignoretimer = (pbuffs["Agresywność"]) },
{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
{ name = "Atak",      use =    true},timer = "SSBleed",
}
end

-- Class: Warden/Warrior
            elseif mainClass == "WARDEN" and subClass == "WARRIOR" then
			
if enemy then
	if (goat2 == "wdw1") then
		Skill = { 
		{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
		{ name = "Mistrz Pulsu",      use = (tbuffs[620690]) and (EnergyBar2 >= 20) },
		{ name = "Bestialskie Cięcie",      use = (EnergyBar2 >= 20) },
		{ name = "Podwójne Cięcie",      use = (EnergyBar1 >= 160) },
		{ name = "Ukośne Cięcie",      use = (EnergyBar1 >= 800) },	
		{ name = "Cięcie",      use = (EnergyBar2 >= 25) },
		{ name = "Action: 5",      use = (EnergyBar1 >= 300) },
		{ name = "Dzikie Ciernie",      use = (EnergyBar1 >= 1100) },
		{ name = "Atak",      use =    true},
		}
	elseif (goat2 == "wdw2") then	
		Skill = {		
		{ name = "Mistrz Pulsu",      use = (tbuffs[620690]) and (tbuffs[502112]) },
		{ name = "Dzikie Ciernie",      use = (tbuffs[502112]) and(EnergyBar1 >= 1100) },
		{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
		{ name = "Bestialskie Cięcie",      use = (EnergyBar2 >= 20) },
		{ name = "Ukośne Cięcie",      use = (EnergyBar1 >= 800) },
		{ name = "Cięcie",      use = (EnergyBar2 >= 25) },
		{ name = "Action: 5",      use = (EnergyBar1 >= 300) },
		{ name = "Atak",      use =    true},
		}

	end
end

-- Class: Warrior/Scout
            elseif mainClass == "WARRIOR" and subClass == "RANGER" then


if enemy then
Skill = { 
{ name = "Ostatnia Bitwa",      use = ( EnergyBar1 >= 25) and (thealth < 0.3) },
{ name =  "ID: 500115" , use = not tDEAD},-- to cos igowego
{ name = "Action: 3",      use = (tbuffs[501502]) and (EnergyBar1 >= 25) },
{ name = "Próbny Atak",      use = (EnergyBar1 >= 20) and (not tbuffs["501502"]) },
{ name = "Cięcie",      use = (EnergyBar1 >= 46) },
{ name = "Łamacz Czaszek",      use = (EnergyBar2 >= 30) },
{ name = "Atak",      use =    true},
}
end

-- Class: Warrior/Rouge
            elseif mainClass == "WARRIOR" and subClass == "THIEF" then


if enemy then
Skill = { 
{ name = "Action: 5",      use = (tbuffs[501502]) and (EnergyBar1 >= 25) },
{ name = "Próbny Atak",      use = (EnergyBar1 >= 20) and (not tbuffs["501502"]) },
{ name = "Cięcie",      use = (EnergyBar1 >= 26) },
{ name = "Cieniste Pchnięcie",      use = (EnergyBar2 >= 20) },
{ name = "Atak",      use =    true},
}

end

-- Class: Warden/Scout
            elseif mainClass == "WARDEN" and subClass == "RANGER" then
			
if enemy then
Skill = { 
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Podporządkowanie",      use = (EnergyBar2 >= 40) },
{ name = "Ukośne Cięcie",      use = (EnergyBar1 >= 800) },
{ name = "Action: 5",      use = (EnergyBar1 >= 300) },
{ name = "Dzikie Ciernie",      use = (EnergyBar1 >= 1100) },
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Atak",      use =    true},
}

end

-- Class: Scout/Warden
            elseif mainClass == "RANGER" and subClass == "WARDEN" then
			--DEFAULT_CHAT_FRAME:AddMessage(goat2)
if enemy then			
	if (goat2 == "swd1") then										
		Skill = { 
		{ name = "Przycelowanie", use = (pbuffs[504588]) },
		{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
		{ name = "Strzał",      use =    true},
		{ name = "Ukryte Niebezpieczeństwo", use = true },
		{ name = "Ciernista Strzała",  	    use =    true},
		{ name = "Salwa",      use =    true},
		{ name = "Przebijająca Strzała",      use =    true},
		{ name = "Wampiryczne Strzały",      use =    true},
		} 
		
	elseif (goat2 == "swd2") then	
		Skill = {
		{ name = "Automatyczny Strzał", use = (not ASon)},
		{ name = "Przycelowanie", use = true },
		{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
		{ name = "Ukryte Niebezpieczeństwo", use = true },
		}

	end
end

-- Class: CH/P
            elseif mainClass == "PSYRON" and subClass == "AUGUR" then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
--{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
--{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 20) and (not tbuffs[621164] or tbuffs[621164].stack<3 or tbuffs[621164].time < 3 ) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) and thealth < 0.30 },
--{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
{ name = "Pulsy Światła",      use = (EnergyBar2 >= 0.01) },
{ name = "Boska Zemsta",      use = (EnergyBar1 >= 15) },
{ name = "Atak",      use =    true},
}
end
-- Class: Ch/m

            elseif mainClass == "PSYRON" and subClass == "MAGE" then
			
if enemy then

 	Skill =  {
				{ name = "Oddalenie",                           use = (EnergyBar1 >= 20) and (pbuffs["Ogłuszenie"]) or (pbuffs["Błyskawica"]) or (pbuffs["Cienista Cela"]) or (pbuffs["Cios Kary"]) or (pbuffs["Święte Okowy"]) },
				{ name = "Przemodelowane Ciało",             	use = (pbuffs["Postać Tarczy"]) and (phealth <= .20) },
				{ name = "Kuźnia",                           	use = ((not pbuffs["Kuźnia"]) or (pbuffs["Kuźnia"].time <= 45)) },
				{ name = "Bariera Wysokiej Energii",         	use = (EnergyBar2 >= 180) and (not pbuffs["Bariera Wysokiej Energii"]) },
				{ name = "Zbroja Odwetu",                    	use = (EnergyBar2 >= 162) and ( not pbuffs["Zbroja Odwetu"]) },
				{ name = "Wzrost Runiczny",                     use = (true) and (phealth <= .60) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Runiczny Puls",                    	use = (pbuffs["Napęd Łańcuchowy"]) },
			    { name = "Nieustraszony Cios",               	use = (EnergyBar1 >= 15) and (thealth <= .29) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Uderzenie Szoku",                     use = (EnergyBar1 >= 25) and (pbuffs["Postać Tarczy"]) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Uderzenie Przypływu Energii",         use = (EnergyBar1 >= 25) and (not pbuffs["Napęd Łańcuchowy"]) and (tbuffs["Porażenie Prądem"]) },
				{ name = "Porażenie Prądem",                    use = (EnergyBar1 >= 20) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Ciężkie Uderzenie",                	use = (EnergyBar1 >= 20) and (not tbuffs["Ciężkie Uderzenie 3"]) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Miażdżąca Ofensywa",                  use = (EnergyBar1 >= 10) and (EnergyBar2 >= 162) and (pbuffs["Krwawe Doświadczenie"]) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Krwawe Doświadczenie",                use = (EnergyBar2 >= 180) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Gwałtowny Rozrzut",                	use = (EnergyBar2 >= 216) and (not pbuffs["Napęd Łańcuchowy"]) },
				{ name = "Atak",                             	use = (thealth > 0) and (not pbuffs["Napęd Łańcuchowy"]) },
						 }

--Skill = { 																									
---{ name = "Plaga Żywiołów",      use = ((tbuffs[502112]) and (tbuffs[621445]) or (tbuffs[502112].time < 1)) },		
---{ name = "Atak",      use =    true },
---}

end	

        -- Class: Knight/Warrior
            elseif mainClass == "KNIGHT" and subClass == "WARRIOR" then
            --Timers for this class
            CreateDIYCETimer("SSBleed", 6.5) --Change the value between 6 -> 7.5 depending on your lag.
            CreateDIYCETimer("LBBleed", 7.5) --Change the value between 7 ->  8.5 depending on your lag.
            --goat2: 0 = Buffs, 1 = Melee, 2 = Ranged, 3 = Cooldowns & Potions, 4 = Longer Cooldowns
            
            if (goat2 == "0") then
            Skill =  {
				{ name = "Wzmocniona Zbroja",                     use = ((not pbuffs["Wzmocniona Zbroja"])) },
				{ name = "Item: Mieszanka Łąkowa",                      use = ((not pbuffs["Mieszanka Łąkowa"]) and (GetCountInBagByName("Mieszanka Łąkowa") ~= 0) ) },
				{ name = "Item: Mikstura Bohatera",                     use = ((not pbuffs["Mikstura Bohatera"]) and (GetCountInBagByName("Mikstura Bohatera") ~= 0) ) },
				{ name = "Item: Smażony Stek Rybny",                     use = ((not pbuffs["Smażony Stek Rybny"]) and (not pbuffs["Smażone Żeberka"]) and (GetCountInBagByName("Smażony Stek Rybny") ~= 0)) },
				{ name = "Item: Smażone Żeberka",                     use = ((not pbuffs["Smażony Stek Rybny"]) and (not pbuffs["Smażone Żeberka"])  and (GetCountInBagByName("Smażone Żeberka") ~= 0) ) },
				{ name = "Item: Deser Waniliowo-Truskawkowy",                     use = ((not pbuffs["Deser Waniliowo-Truskawkowy"])and (GetCountInBagByName("Deser Waniliowo-Truskawkowy") ~= 0)) },
				{ name = "Item: Elegancka Potrawa",                     use = ((not pbuffs["Przysmak Wykwintnej Kuchni"]) and (GetCountInBagByName("Elegancka Potrawa") ~= 0)) },
				{ name = "Item: Eliksir: Nieokiełznany Entuzjazm",                     use = ((not pbuffs["Nieokiełznany Entuzjazm"]) and (GetCountInBagByName("Eliksir: Nieokiełznany Entuzjazm") ~= 0)) },
				{ name = "Item: Eliksir: Szkarłatna Miłość",                     use = ((not pbuffs["Szkarłatna Miłość"]) and (GetCountInBagByName("Eliksir: Szkarłatna Miłość") ~= 0)) },
                     }
            elseif (goat2 == "3") then
            Skill =  {
               { name = "Action: 69 (Nieznany Wybór)",         use = ((EnergyBar1 > 20)) },
               { name = "Action: 68 (Wyjątkowa Kanapka z Kawiorem Przyrządzona Przez Pomoc Domową)",        use = ((not pbuffs["Wyjątkowa Kanapka z Kawiorem Przyrządzona Przez Pomoc Domową"])) },
                     }
            elseif (goat2 == "4") then
            Skill = {
				{ name = "Item: Mikstura Bohatera",                     use = ((not pbuffs["Mikstura Bohatera"]) and (GetCountInBagByName("Mikstura Bohatera") ~= 0) ) },
				{ name = "Item: Smażony Stek Rybny",                     use = ((not pbuffs["Smażony Stek Rybny"]) and (not pbuffs["Smażone Żeberka"]) and (GetCountInBagByName("Smażony Stek Rybny") ~= 0)) },
				{ name = "Item: Smażone Żeberka",                     use = ((not pbuffs["Smażony Stek Rybny"]) and (not pbuffs["Smażone Żeberka"])  and (GetCountInBagByName("Smażone Żeberka") ~= 0) ) },
			
				{ name = "Item: Wyjątkowa Kanapka z Kawiorem Przyrządzona przez Pomoc Domową",                     use = ((not pbuffs["Kanapka z Kawiorem"]) and (GetCountInBagByName("Wyjątkowa Kanapka z Kawiorem Przyrządzona przez Pomoc Domową") ~= 0) ) },
				{ name = "Postanowienie",                     use = ((not pbuffs["Postanowienie"])) },		
				{ name = "Tarcza Dyscypliny",                     use = ((not pbuffs["Tarcza Dyscypliny"])) },	
				{ name = "Szybki Refleks",                     use = ((not pbuffs["Szybkie Refleksy"]) and EnergyBar2>=20) },	
				{ name = "Mistrz Parowania",                     use = ((not pbuffs["Mistrz Parowania"]) and EnergyBar2>=30) },
				{ name = "Berserk",                     use = ((not pbuffs["Berserk"]) and EnergyBar2>=25) },
				{ name = "Wybuch Świętej Mocy",                     use = ((not pbuffs["Wybuch Świętej Mocy"]) and EnergyBar1>=150) },
                { name = "Komnata Poległych Bohaterów",                     use = ((not pbuffs["Ochrona Komnaty Poległych"]) and EnergyBar1>=150) },
				{ name = "Tarcza Odwagi", use = (EnergyBar1 >= 180) and (not pbuffs["Tarcza Odwagi"]) },
				
				{ name = "Item: Silny Stymulant",      use = ((not pbuffs["Silny Stymulant"]) and (not pbuffs["Szaleńczy Atak"]) and (GetCountInBagByName("Silny Stymulant") ~= 0)) },				
				{ name = "Item: Eliksir Szaleństwa",                     use = ((not pbuffs["Eliksir Szaleństwa"]) and (GetCountInBagByName("Eliksir Szaleństwa") ~= 0) ) },
				
				--{ name = "Atak",						use = (thealth > 0) },
                    }
            end

            if ((enemy) and (goat2 == "1")) then
            Skill2 = {
				{ name = "Święta Siła", use = (EnergyBar1 >= 300) and (not pbuffs["Święta Siła"]) }, 
				-- Jesli poczatek walki trzeba szybciej złapac aggro
				{ name = "Wybuch Świętej Mocy", use = ((not pbuffs["Wybuch Świętej Mocy"]) and EnergyBar1>=150 and thealth > 0.85 ) },
				{ name = "Zagrożenie", use = (EnergyBar1 >= 180) and (not pbuffs["Zagrożenie"]) and (tbuffs["Święta Pieczęć 1"] or tbuffs["Święta Pieczęć 2"] or tbuffs["Święta Pieczęć 3"] or tbuffs["Święta Pieczęć 4"]) and thealth > 0.85 },
				{ name = "Uderzenie Tarczą Prawdy", use = (EnergyBar1 >= 144) and (pbuffs["Wybuch Świętej Mocy"]) and (tbuffs["Święta Pieczęć 1"] or tbuffs["Święta Pieczęć 2"] or tbuffs["Święta Pieczęć 3"] or tbuffs["Święta Pieczęć 4"]) and thealth > 0.85 },
				{ name = "Święty Cios", use = (EnergyBar1 >= 216) and thealth > 0.85 },
				{ name = "Wirująca Tarcza", use = (EnergyBar1 >= 288) and thealth > 0.85 }, 
				{ name = "Cięcie", use = (EnergyBar2 >= 25) and thealth > 0.85 }, 
			
				-- Dalej standardowo
				{ name = "Tarcza Odwagi", use = (EnergyBar1 >= 180) and (not pbuffs["Tarcza Odwagi"]) }, 
				{ name = "Szybki Refleks",                     use = ((not pbuffs["Szybkie Refleksy"]) and EnergyBar2>=20) },	
				{ name = "Mistrz Parowania",                     use = ((not pbuffs["Mistrz Parowania"]) and EnergyBar2>=30) },
			
				{ name = "Święta Pieczęć", use = (EnergyBar1 >= 240) and (not tbuffs["Święta Pieczęć 4"]) and (not tbuffs["Święta Pieczęć 3"]) },
				{ name = "Zagrożenie", use = (EnergyBar1 >= 180) and (not pbuffs["Zagrożenie"]) and (tbuffs["Święta Pieczęć 4"]) },
				{ name = "Wybuch Świętej Mocy", use = ((not pbuffs["Wybuch Świętej Mocy"]) and EnergyBar1>=150) },
				{ name = "Uderzenie Tarczą Prawdy", use = (EnergyBar1 >= 144) and (pbuffs["Wybuch Świętej Mocy"]) and (tbuffs["Święta Pieczęć 4"]) },
				{ name = "Kara", use = (EnergyBar1 >= 160) and (tbuffs["Święta Pieczęć 4"]) },
				{ name = "Wirująca Tarcza", use = (EnergyBar1 >= 288) }, 
				{ name = "Święty Cios", use = (EnergyBar1 >= 216) },
                { name = "Cięcie", use = (EnergyBar2 >= 25) }, 
                { name = "Atak", use = (thealth > 0) },
                    }
            elseif ((enemy) and (goat2 == "2")) then
            Skill2 = {
                { name = "Premedytacja",                use = (EnergyBar1 >= 34) and (((tbuffs[620313]) or (tbuffs[500654])) and (tbuffs[620314])) },
                { name = "Cios w Ranę",                 use = (EnergyBar1 >= 34) and (((tbuffs[620313]) or (tbuffs[500654])) and (tbuffs[620314])) },
				{ name = "Cieniste Pchnięcie",             use = (EnergyBar1 >= 20) and ((not tbuffs[620313]) and (not tbuffs[500654])),	timer = "SSBleed" },
				{ name = "Cios Poniżej Pasa",           use = (EnergyBar1 >= 29) },
				{ name = "Atak",						use = (thealth == 1) },
                     }
            end


-- Class: CH/R
            elseif mainClass == "PSYRON" and subClass == "THIEF" then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
--{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Cieniste Pchnięcie",      use = (EnergyBar2 >= 20) },
{ name = "Rzut",      use = true },
{ name = "Nieustraszone Ciosy",      use = (EnergyBar1 >= 15) and thealth < 0.45 },
{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
--{ name = "Pulsy Światła",      use = (EnergyBar2 >= 0.01) },
--{ name = "Boska Zemsta",      use = (EnergyBar1 >= 15) },
{ name = "Atak",      use =    true},
}
end
--ADD MORE CLASS COMBOS HERE. 
            --USE AN "ELSEIF" TO CONTINUE WITH MORE CLASS COMBOS.````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
            --THE NEXT "END" STATEMENT IS THE END OF THE CLASS COMBOS STATEMENTS.
            --DO NOT POST BELOW THE FOLLOWING "END" STATEMENT!
            end
    --End Player Skill Sequences
    
 if (arg1=="debugskills") then  --Used for printing the skill table, and true/false usability
  DIYCE_DebugSkills(Skill)
  DIYCE_DebugSkills(Skill2)
 elseif (arg1=="debugpbuffs") then --Used for printing your buff names, and buffID
  DIYCE_DebugBuffList(pbuffs)
 elseif (arg1=="debugtbuffs") then --Used for printing target buff names, and buffID
  DIYCE_DebugBuffList(tbuffs)
 elseif (arg1=="debugall") then  --Used for printing all of the above at the same time
  DIYCE_DebugSkills(Skill)
  DIYCE_DebugSkills(Skill2)
  DIYCE_DebugBuffList(pbuffs)
  DIYCE_DebugBuffList(tbuffs)
 end
 
    if (not MyCombat(Skill, arg1)) then
        MyCombat(Skill2, arg1)
    end
        
    --Select Next Enemy
 if (tDead) then
  TargetUnit("")
  return
 end
 if mainClass == "MAGE" and (not party) then  --To keep scouts from pulling mobs without meaning to.
  if (not LockedOn) or (not enemy) then
   TargetNearestEnemy()
   return
  end
 elseif mainClass ~= "MAGE" then     --Let all other classes auto target.
  if (not LockedOn) or (not enemy) then
   TargetNearestEnemy()
   return
  end
 end
end
DEFAULT_CHAT_FRAME:AddMessage("CustomFunctions.lua has loaded")