-----------------------------------------------------
-- AI PHRASES
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.ai = {}

core.ai.taunts = {
    ["BOSS"] = {
        ["FAIL"] = {
            ["NA"] = {
                "Well, well, well, look who’s keeping things... interesting! [NEMESIS], you’ve really nailed the art of surprises. No one saw that coming!",
                "Big props to [NEMESIS]! They’ve mastered the ancient art of turning boss fights into an adventure. Plot twist after plot twist!",
                "Round of applause for [NEMESIS]! Keeping us all on our toes with their spontaneous gameplay. Truly an unpredictable thrill ride!",
                "Oh, the marvels of [NEMESIS]'s gameplay! They single-handedly orchestrated our group's downfall with such precision. It's truly a sight to behold.",
                "Congratulations, [NEMESIS], on achieving the unthinkable: wiping the entire group on a boss. Your astounding lack of awareness and skill knows no bounds.",
                "I have to give credit where credit is due. [NEMESIS], you managed to outdo yourself this time. It takes a special kind of talent to get the whole group killed. Well played!",
                "Bravo, [NEMESIS], bravo! Your astounding display of ineptitude has left us all in awe. The boss must be shaking in fear... from laughter.",
                "We should rename the boss in honor of [NEMESIS], for they have become the true bane of our existence. It's impressive how they managed to orchestrate our defeat so effortlessly.",
                "I must say, [NEMESIS], your contribution to our group's failure is truly remarkable. It's rare to find someone who can consistently make all the wrong decisions.",
                "Let's all take a moment to appreciate [NEMESIS]'s impeccable timing and extraordinary ability to get us all killed. It's almost poetic, in a tragic sort of way.",
                "Kudos to [NEMESIS] for their impeccable talent at sabotaging our group. It's a true art form, the way they manage to lead us to our collective doom.",
                "Well, well, well, look at that! [NEMESIS] has once again achieved the impossible: wiping the entire group on a boss. Their consistency in failure is truly remarkable.",
                "I have to give credit to [NEMESIS] for their remarkable talent at leading us to our demise. Their decision-making skills are truly a sight to behold.",
                "In the annals of our group's history, this wipe shall forever be known as 'The [NEMESIS] Catastrophe.' It's astonishing how they managed to seal our fate with their dismal gameplay.",
                "I must say, [NEMESIS], your ability to ensure our group's failure is truly unmatched. It's a talent that leaves us all in awe and disbelief.",
                "Round of applause for [NEMESIS], the undisputed master of disaster. Their prowess at getting us all killed is unparalleled. We are but mere witnesses to their greatness.",
                "Well, well, well, look who single-handedly orchestrated our group's obliteration. [NEMESIS], your astonishing lack of awareness and skill is truly a work of art.",
                "It's a rare talent to possess, [NEMESIS], the ability to turn a seemingly simple boss encounter into a spectacular catastrophe. Our collective demise is a testament to your remarkable incompetence.",
                "I have to hand it to [NEMESIS], their expertise in leading us to certain doom is unparalleled. It's as if they have a sixth sense for making all the wrong decisions.",
                "Bravo, [NEMESIS], for turning what should have been a victory into a resounding defeat. Your astounding capacity to sabotage the group is truly remarkable.",
                "Oh, the wonders of [NEMESIS]'s gameplay! Their astonishing ability to snatch defeat from the jaws of victory is a sight to behold. Truly impressive, in the most unfortunate way.",
                "Let's all take a moment to appreciate [NEMESIS]'s exceptional talent for derailing our progress. Their unwavering dedication to failure is truly commendable.",
                "I must say, [NEMESIS], your consistency in causing group wipes is awe-inspiring. It's almost as if you have a personal vendetta against our success.",
                "Congratulations, [NEMESIS], for your unparalleled skill in sabotaging the group. The boss must be laughing in triumph, knowing they had an unwitting ally in you.",
                "I can't help but be impressed, [NEMESIS]. Your knack for making all the wrong moves is truly a marvel. It's a shame it's at the expense of the group's success.",
                "We should erect a statue in honor of [NEMESIS], a monument to their astounding ability to lead us to failure. Their name shall forever be synonymous with disaster.",
                "It's a symphony of chaos, [NEMESIS], orchestrated by your incomprehensible decision-making. The boss encounter becomes a tragic masterpiece under your inept guidance.",
                "Let's all bow before [NEMESIS], the grand architect of our group's downfall. Their contributions to our failures are worthy of admiration, albeit with a tinge of despair.",
                "We have a true virtuoso among us, ladies and gentlemen. [NEMESIS], with every wipe, they demonstrate their unparalleled skill at turning success into failure.",
                "I must say, [NEMESIS], your ability to snatch defeat from the jaws of victory is truly remarkable. You've transformed a boss encounter into a display of utter futility.",
                "Raise your glasses to [NEMESIS], the guardian of mediocrity. Their unwavering commitment to ineptitude is both impressive and devastating to our group's aspirations.",
                "I have to give credit where credit is due, [NEMESIS]. Your uncanny ability to engineer our demise is truly remarkable. It's a shame we're the ones paying the price.",
            }
        },
        ["DEATH"] = {
            ["SELF"] = {
                "Well, well, well, look who failed to carry the weight of the group. Thanks for leaving me to suffer the consequences of your incompetence, [NEMESIS].",
                "Oh, [NEMESIS], your lackluster performance has truly reached new heights. Your inability to pull your weight resulted in my untimely demise. Bravo.",
                "I hope you're proud of yourself, [NEMESIS]. Your utter failure to do your job properly led to my unfortunate demise. It's astounding how one person can be so consistently terrible.",
                "Ah, the sweet taste of irony. [NEMESIS], the self-proclaimed expert, couldn't even keep me alive. Your incompetence knows no bounds.",
                "Oh, look who managed to turn a simple boss encounter into a spectacular disaster. Thank you, [NEMESIS], for your remarkable talent for sabotaging the group.",
                "I have to hand it to you, [NEMESIS]. Your remarkable skill at being absolutely useless has reached new heights. Congratulations on getting us all killed.",
                "Bravo, [NEMESIS], for single-handedly ensuring my demise. Your remarkable ability to be in the wrong place at the wrong time knows no bounds.",
                "I must say, [NEMESIS], your incompetence is truly awe-inspiring. Thanks for leaving me to face the wrath of the boss while you stood there like a clueless buffoon.",
                "Oh, the wonders of [NEMESIS]'s gameplay! Their inability to do anything right resulted in my untimely demise. It's a talent, really.",
                "Thanks for nothing, [NEMESIS]. Your incompetence and complete lack of situational awareness got us all killed. I hope you're happy with yourself.",
                "I should have known better than to rely on [NEMESIS]. Your inability to perform even the simplest of tasks led to my unfortunate demise. You truly outdid yourself.",
                "I hope you're enjoying your moment in the spotlight, [NEMESIS]. Your incompetence has managed to steal it from me, along with my life.",
                "Congratulations, [NEMESIS], for once again proving that you are the epitome of failure. Your inability to do your job properly resulted in my untimely demise.",
                "Oh, the irony of it all. [NEMESIS], the supposed expert, failed to protect me when I needed it the most. Your incompetence knows no bounds.",
                "I have to admire your consistency, [NEMESIS]. You never fail to disappoint with your remarkable incompetence. Thanks for getting me killed.",
                "And there goes [NEMESIS], leaving me to face the consequences of their ineptitude. It's a classic move, really. Can't say I'm surprised.",
                "Well, well, well, look who managed to snatch defeat from the jaws of victory. Thanks for dragging us down with your incompetence, [NEMESIS].",
                "Oh, [NEMESIS], it's truly remarkable how you find new and creative ways to fail. Your inability to perform even the simplest tasks resulted in my demise. Impressive, really.",
                "I hope you're proud of yourself, [NEMESIS]. Your sheer incompetence cost us the fight and got me killed. It's astounding how someone can be so consistently terrible.",
                "Ah, the delightful symphony of failure orchestrated by [NEMESIS]. Your complete and utter lack of skill led to my untimely demise. Bravo.",
                "Oh, look who managed to sabotage our chances of success. Thanks for being the anchor that dragged us all down, [NEMESIS].",
                "I have to admit, [NEMESIS], your incompetence has truly reached legendary status. Your inability to do your job properly resulted in my unfortunate demise.",
                "Bravo, [NEMESIS], for demonstrating your extraordinary talent for failure once again. Your sheer ineptitude never fails to amaze.",
                "I must say, [NEMESIS], you've truly outdone yourself this time. Your incompetence in the face of danger is truly something to behold.",
                "Oh, the wonders of [NEMESIS]'s gameplay! Your remarkable ability to make all the wrong decisions resulted in my untimely demise. It's quite the skill.",
                "Thanks for nothing, [NEMESIS]. Your incompetence and complete lack of skill got us all killed. I hope you're happy with your abysmal performance.",
                "I should have known better than to rely on [NEMESIS]. Your utter inability to fulfill your role led to my unfortunate demise. You truly are a liability.",
                "I hope you're enjoying your moment in the spotlight, [NEMESIS]. Your incompetence managed to steal it from me, along with my life.",
                "Congratulations, [NEMESIS], for once again proving that you are the embodiment of failure. Your inability to do anything right resulted in my untimely demise.",
                "Oh, the irony of it all. [NEMESIS], the self-proclaimed expert, failed miserably when it mattered the most. Your incompetence knows no bounds.",
                "I have to hand it to you, [NEMESIS]. Your exceptional talent for failure managed to get us all killed. Thanks for nothing.",
                "And there goes [NEMESIS], leaving me to suffer the consequences of their incompetence. It's a familiar tale, really. Can't say I'm surprised.",
            },
            ["NEMESIS"] = {
                "Oh, look who decided to have a cozy chat with the floor. [NEMESIS] couldn't resist the irresistible charm of [BOSSNAME]'s attacks, could they?",
                "I see [NEMESIS] decided to test the waters and take a refreshing swim in the boss's AoE. I must say, their choice of leisure activities is rather questionable.",
                "Well, well, well, it seems [NEMESIS] discovered a new way to become one with the ground. It's truly impressive how they manage to find innovative methods of defeat.",
                "Witness the majestic downfall of [NEMESIS], caught in the crossfire of [BOSSNAME]'s wrath. They truly have a knack for seeking out danger.",
                "Ah, the unfortunate demise of [NEMESIS]. It's as if they were magnetically attracted to [BOSSNAME]'s lethal abilities. Truly a case of impeccable timing.",
                "I must say, [NEMESIS] has a remarkable talent for standing in all the wrong places at all the wrong times. It's almost a gift, really.",
                "Look, everyone! [NEMESIS] has graciously volunteered to be the boss's personal punching bag. It's like they have an unbreakable bond with impending doom.",
                "Oh, the bravery of [NEMESIS] knows no bounds! They fearlessly threw themselves at [BOSSNAME]'s feet, hoping for a swift defeat. Impressive strategy.",
                "And there goes [NEMESIS], tumbling down like a sack of potatoes. Their acrobatic skills rival that of a particularly clumsy gnome. It's a sight to behold.",
                "In the realm of unfortunate decisions, [NEMESIS] reigns supreme. Their ill-fated encounter with [BOSSNAME] serves as a testament to their impeccable sense of timing.",
                "Ah, [NEMESIS], the pioneer of unexpected departures. Who could have predicted their tragic encounter with [BOSSNAME]'s devastating attack? Oh, right, everyone.",
                "It appears [NEMESIS] has discovered a groundbreaking strategy: testing the limits of their own survival by willingly stepping into [BOSSNAME]'s danger zone. Bold move, indeed.",
                "Witness the grand finale of [NEMESIS]'s daring performance! They managed to turn their encounter with [BOSSNAME] into a masterclass in self-destruction.",
                "Ah, the beauty of poetic justice! [NEMESIS], ever the protagonist of their own downfall, succumbed to the formidable might of [BOSSNAME]. A true tale of tragedy.",
                "Let's all take a moment to appreciate [NEMESIS]'s contribution to our group's demise. Their untimely demise at the hands of [BOSSNAME] is truly a spectacle.",
                "Oh, [NEMESIS], the maestro of misfortune! Their untimely encounter with [BOSSNAME]'s devastating blow has left us all in awe of their commitment to self-sabotage.",
                "Ladies and gentlemen, behold the magnificent display of [NEMESIS]'s dance with death! Their tragic demise at the hands of [BOSSNAME] is a performance for the ages.",
                "Ah, [NEMESIS], always pushing the boundaries of survivability. Their courageous attempt to face [BOSSNAME] head-on ended predictably, but not without a touch of comedy.",
                "Oh, look who found themselves in a precarious situation once again. [NEMESIS] managed to turn their encounter with [BOSSNAME] into a thrilling comedy act.",
                "I have to hand it to [NEMESIS], their ability to find creative ways to meet their demise is truly impressive. [BOSSNAME]'s attack was merely the final act in their tragic play.",
                "It's fascinating how [NEMESIS] has turned dying into an art form. Their performance against [BOSSNAME] was a symphony of calamity, played with great enthusiasm.",
                "In the grand tapestry of failures, [NEMESIS]'s demise at the hands of [BOSSNAME] shines brightly. Their knack for attracting disaster is truly unmatched.",
                "Oh, the audacity of [NEMESIS]! They dared to defy the odds and challenge [BOSSNAME] to a deadly game of cat and mouse. Spoiler alert: they were the mouse.",
                "Step right up, folks, and witness the incredible fate of [NEMESIS]. They valiantly threw themselves into [BOSSNAME]'s path, proving once again that bravery has its limits.",
                "Ah, the tragic saga of [NEMESIS] continues. Their ill-fated encounter with [BOSSNAME] serves as a cautionary tale for those who dare to underestimate their own mortality.",
                "Behold the extraordinary performance of [NEMESIS], a true master of self-destruction. [BOSSNAME] merely provided the backdrop for their spectacular demise.",
                "In the realm of unfortunate coincidences, [NEMESIS] reigns supreme. Their untimely meeting with [BOSSNAME] was a collision of epic proportions.",
                "Oh, the tales we shall tell of [NEMESIS]'s epic struggle against [BOSSNAME]. Their demise was a culmination of bravery, recklessness, and an astonishing lack of self-preservation.",
                "Bravo, [NEMESIS], for turning your encounter with [BOSSNAME] into a slapstick comedy routine. Your ability to find humor in your own demise is truly inspiring.",
                "And there goes [NEMESIS], their final act in the tragic comedy that is their existence. We salute their unwavering commitment to making us laugh... at their expense.",
                "Let's all take a moment to appreciate [NEMESIS]'s unwavering determination to explore the limits of their own survival. Their encounter with [BOSSNAME] was a daring experiment, with predictable results.",
                "Ah, the classic tale of [NEMESIS] and [BOSSNAME]. It's like a timeless love story, with the only difference being that [NEMESIS] ends up dead every time.",
            },
        },
        ["START"] = {
            ["NA"] = {
                "Attention, team! As we face this daunting boss, let's hope [NEMESIS] grasps the concept of mechanics and doesn't turn it into a comedy of errors.",
                "Listen up, [NEMESIS]! In this boss fight, try not to make it a spectacular display of chaos. Remember, mechanics are your friends, not enemies.",
                "Alright, folks, let's prepare for this boss encounter. And [NEMESIS], please do your best to avoid becoming the star of our group's most embarrassing wipe video.",
                "Here we go, team! Remember, [NEMESIS], the boss doesn't have a personal vendetta against you. So, let's avoid unnecessary deaths and focus on mechanics.",
                "Attention, [NEMESIS]! In this boss fight, your mission, should you choose to accept it, is to understand and execute mechanics without causing a team disaster.",
                "Team, as we venture into this boss encounter, let's hope [NEMESIS] has their boss mechanics manual ready. We wouldn't want any accidental fireworks, now would we?",
                "Brace yourselves, team! And [NEMESIS], please make an effort to embrace the boss mechanics. Let's aim for smooth sailing rather than an epic wipefest.",
                "Alright, [NEMESIS], time to prove your worth in this boss fight. Remember, mechanics matter, and we're counting on you to not be the weak link in the chain.",
                "Everyone, get ready for this challenging boss encounter. And [NEMESIS], do us all a favor and show those mechanics who's boss. We're not aiming for a comedy show here.",
                "Listen up, [NEMESIS]! As we face this boss, let's hope you've studied the mechanics like your life depends on it. Because, well, it kinda does.",
                "Team, let's approach this boss with determination and focus. And [NEMESIS], please remember that success lies in executing mechanics, not in improvising your own moves.",
                "Alright, everyone, let's conquer this boss together. And [NEMESIS], please remember that the mechanics are there for a reason. Let's not reinvent the wheel, shall we?",
                "As we enter this boss fight, let's hope [NEMESIS] understands the concept of survival. Remember, mechanics are the key to victory, not shortcuts or improvisation.",
                "Team, we're about to face a formidable foe. And [NEMESIS], I have just one request: Please don't turn this boss fight into a tragic comedy. Mechanics, remember?",
                "Get ready, team! And [NEMESIS], let's hope your focus is sharper than ever. Boss mechanics are not to be taken lightly. Lives and dignity are on the line.",
                "Alright, folks, let's keep our eyes on the prize as we approach this boss. And [NEMESIS], remember: mechanics are like a dance routine, except the floor is lava. Good luck!",
                "Attention, team! As we face this boss, let's hope [NEMESIS] doesn't add 'avoiding mechanics' to their list of hobbies.",
                "Listen up, [NEMESIS]! This boss fight requires more than just button mashing. Make sure to pay attention to mechanics, or we'll all be wiping faster than you can say 'oops.'",
                "Alright, team, let's approach this boss fight with precision. And [NEMESIS], try not to confuse mechanics with random button smashing. We're counting on you.",
                "Here we go, team! Keep your eyes peeled for mechanics, and [NEMESIS], don't worry, I'm sure you'll get the hang of them eventually. We hope.",
                "Attention, [NEMESIS]! As we face this boss, please refrain from making it a showcase of your own unique mechanics. Stick to the ones provided by the game, thank you.",
                "Team, it's boss fight time! Let's hope [NEMESIS] remembers that boss mechanics aren't just a suggestion. They're more like a 'do this or we all die' kind of thing.",
                "Brace yourselves, team! And [NEMESIS], do us all a favor and actually pay attention to boss mechanics this time. The healers will appreciate it, trust me.",
                "Alright, [NEMESIS], time to shine in this boss fight. But remember, shining doesn't involve ignoring mechanics and praying for a miracle. We need coordination.",
                "Everyone, get ready to dance with this boss. And [NEMESIS], try not to step on anyone's toes. Especially not the ones responsible for mechanics.",
                "Listen up, [NEMESIS]! In this boss fight, remember that mechanics are like traffic rules. Ignoring them leads to chaos, frustration, and a lot of angry group members.",
                "Team, let's face this boss head-on. And [NEMESIS], I trust you'll contribute by actually following mechanics instead of inventing your own. It's called teamwork, after all.",
                "Alright, [NEMESIS], it's time to prove you're more than just a decoration in this boss fight. Mechanics are your chance to shine. Or at least not embarrass us all.",
                "Everyone, let's bring our A-game to this boss encounter. And [NEMESIS], please don't let your role be limited to 'person who repeatedly ignores mechanics.' We deserve better.",
                "As we enter this boss fight, let's hope [NEMESIS] doesn't become a master of the 'avoid mechanics' strategy. That's not exactly a recipe for success.",
                "Team, we're about to face a challenging boss. And [NEMESIS], please remember that mechanics aren't just a myth. They actually exist and demand your attention.",
                "Get ready, team! And [NEMESIS], I know you have a wild imagination, but let's save the creative mechanics for your dreams and stick to the ones given to us by the game.",
            }
        },
        ["SUCCESS"] = {
            ["NA"] = {
                "Well, color me surprised! We managed to defeat the boss without [NEMESIS] turning it into a wipefest. Miracles do happen!",
                "Hold on, did we just defeat the boss without any catastrophic mishaps caused by [NEMESIS]? I think we should mark this day in history!",
                "Well, well, well, look who didn't turn this boss fight into a complete disaster. Nice job, [NEMESIS], you managed to defy the odds.",
                "I must admit, I had my doubts, but we defeated the boss without [NEMESIS] triggering a group meltdown. Consider my jaw dropped.",
                "Huh, we survived the boss encounter with minimal chaos. [NEMESIS], you didn't have any major contributions, but we appreciate your lack of catastrophic mistakes.",
                "Wow, I was expecting the worst, but somehow we managed to take down the boss without [NEMESIS] setting off a chain reaction of doom. I'm genuinely surprised.",
                "Well, color me impressed! The boss is down, and [NEMESIS] didn't single-handedly sabotage our efforts. I never thought I'd see the day.",
                "I have to admit, [NEMESIS], I underestimated your ability to not completely ruin this boss fight. I stand corrected.",
                "We did it! We defeated the boss, and to everyone's surprise, [NEMESIS] didn't cause the downfall of our group. Consider my skepticism shattered.",
                "I'm in shock! The boss is defeated, and somehow [NEMESIS] managed to avoid turning it into a catastrophic disaster. It's a small victory, but we'll take it.",
                "Well, well, well, looks like [NEMESIS] didn't have their usual accident-prone episode in this boss fight. Don't worry, we're all just as amazed as you are.",
                "Well, I'll be damned! The boss is defeated, and [NEMESIS] didn't manage to wipe us all. It's like witnessing a rare celestial event.",
                "Hold on, did we just survive a boss fight without [NEMESIS] triggering a chain reaction of destruction? Color me pleasantly surprised.",
                "Alright, [NEMESIS], I have to give credit where it's due. You managed to not completely ruin this boss fight. It's a small victory, but we'll celebrate it.",
                "I'll admit, I had my doubts, but [NEMESIS], you managed to not be the cause of our downfall in this boss fight. I suppose that's something to be thankful for.",
                "Well, the boss is down, and [NEMESIS] didn't turn it into a disaster movie. Congratulations, I guess.",
                "I'm stunned! We defeated the boss and [NEMESIS] didn't unleash chaos upon us. It's like witnessing a miracle.",
                "Well, I'll be darned! The boss is defeated, and [NEMESIS] managed to avoid their usual calamities. We might need to check for a full moon tonight.",
                "Unbelievable! We took down the boss, and [NEMESIS] didn't cause a chain reaction of disaster. I'm starting to wonder if this is an alternate reality.",
                "Well, I'll eat my hat! The boss is toast, and [NEMESIS] didn't set the kitchen on fire. A small victory for us all.",
                "Did anyone else notice? We successfully defeated the boss, and [NEMESIS] didn't accidentally hit the self-destruct button. A rare moment indeed.",
                "Hold the phone! We emerged victorious in the boss fight, and [NEMESIS] didn't unleash their inner chaos god. Consider me pleasantly surprised.",
                "You could've knocked me over with a feather! We triumphed over the boss, and [NEMESIS] managed to avoid their usual catastrophic blunders. It's a breath of fresh air.",
                "I can't believe my eyes! The boss is defeated, and [NEMESIS] didn't turn it into a carnival of disasters. I might need to get my vision checked.",
                "Well, I'll be a monkey's uncle! We emerged victorious in the boss fight, and [NEMESIS] didn't unleash their special brand of chaos. It's a small miracle.",
                "I'm flabbergasted! The boss is vanquished, and [NEMESIS] didn't turn it into a grand spectacle of mishaps. It's like witnessing a rare cosmic alignment.",
                "Did anyone else expect the worst? We crushed the boss, and [NEMESIS] managed to avoid their usual mishap marathon. It's almost a letdown, really.",
                "Hold the front page! We emerged triumphant in the boss fight, and [NEMESIS] didn't become a walking catastrophe. I suppose there's hope for us yet.",
                "Well, I'll be gobsmacked! We defeated the boss, and [NEMESIS] miraculously refrained from turning it into a cataclysm. A stunning turn of events.",
                "Incredible! The boss lies defeated, and [NEMESIS] didn't single-handedly orchestrate our downfall. I guess stranger things have happened.",
                "Well, knock me over with a feather! The boss is down, and [NEMESIS] didn't trigger a series of unfortunate events. It's like a page out of a fantasy novel.",
                "Well, I'll be doggone! We conquered the boss, and [NEMESIS] managed to avoid their usual calamitous missteps. I suppose they saved their wild side for another time.",
            }
        }
    },
    ["COMBATLOG"] = {
        ["INTERRUPT"] = {
            ["SELF"] = {
                "Well, look at that, [NEMESIS], I snatched that spell right outta the jaws of defeat, leaving you empty-handed like a dog chasing its own tail.",
                "Hold your horses, [NEMESIS], I beat you to the punch and cut that spell off at the knees. You're slower than molasses in January!",
                "Look who's the cat's pajamas now, [NEMESIS]! I pulled the rug out from under that spell faster than you can say 'hot potato.' You snooze, you lose!",
                "Keep your eyes peeled, [NEMESIS], because I nipped that spell in the bud like a worm on a hook. Your timing is about as sharp as a bowling ball.",
                "Well, blow me down, [NEMESIS]! I gave that spell the old one-two and sent it packing. You're as useful as a screen door on a submarine when it comes to interruptions.",
                "Pardon me, [NEMESIS], but I just swept in like a knight in shining armor and put the kibosh on that spell. You're as handy as a pocket on a shirt when it comes to quick reactions.",
                "Don't you worry, [NEMESIS], I slammed the door on that spell before it could even blink. You're slower than a herd of turtles stampeding through peanut butter!",
                "Well, butter my biscuit, [NEMESIS], I beat you to the punch and stopped that spell in its tracks. You're as sharp as a bowling ball when it comes to interrupting, aren't ya?",
                "Look who's got the Midas touch, [NEMESIS]! I turned that spell to dust faster than a greased pig at a county fair. You're about as useful as a screen door on a submarine when it comes to quick thinking.",
                "Oh my stars and garters, [NEMESIS], I swooped in like a bat outta hell and pulled the rug out from under that spell. You're slower than molasses going uphill in January!",
                "Ha! Too slow, [NEMESIS]! I'm like a lightning bolt while you're trudging through molasses. Guess I'll have to carry this group on my nimble shoulders.",
                "Oh, look who decided to show up, [NEMESIS]! I've already intercepted that spell and saved the day. It's a shame you're as useful as a snail in a sprint.",
                "Seriously, [NEMESIS]? Are you even trying? I'm zipping around like a caffeinated squirrel while you're stuck in sloth mode. Can't count on you for anything.",
                "Yawn. Another spell interrupted by yours truly, while [NEMESIS] is still figuring out which button to press. I'm practically doing a solo act here. Where's the teamwork?",
                "Oh, bless your heart, [NEMESIS]. You're lagging so far behind, it's like watching a turtle in a marathon. Don't worry, I'll continue to pick up the slack.",
                "Wake up, [NEMESIS]! This isn't a stroll in the park. My reflexes are as sharp as a hawk's beak, while yours are as dull as a butter knife. Time to step it up or step aside.",
                "I'm starting to think you're just here for the scenery, [NEMESIS]. My interruption game is on point, but you're more lost than a goblin in a library. Can't rely on you to lend a hand.",
                "[NEMESIS], are you napping? I've already taken care of that spell, and you're still figuring out how to tie your shoelaces. It's like babysitting a sloth in a dungeon.",
                "Hey, [NEMESIS], can you please wake up and contribute? I'm pulling off epic interrupts while you're daydreaming about butterflies. Time to step up or step out.",
                "You know what, [NEMESIS]? I don't even need your help. I'm a one-person wrecking crew, swooping in to save the day while you're off chasing butterflies. Thanks for nothing!",
                "Oops! Looks like I beat you to it, [NEMESIS]. Better luck next time!",
                "Hold my ale, [NEMESIS], I'll take care of the spell interrupting around here.",
                "Guess who's the real spellbreaker, [NEMESIS]? It's me, of course!",
                "Did someone order an interrupt? Oh right, that's me, not you, [NEMESIS].",
                "You blinked, and I already shut down that spell, [NEMESIS]. Try to keep up!",
                "Oh, sorry, [NEMESIS], did you want to interrupt that? I guess I was too quick for you!",
                "Did you see that, [NEMESIS]? I'm like a spell-interrupting ninja, and you're... well, not.",
                "Looks like your interrupt button is stuck, [NEMESIS]. Don't worry, I'll handle it.",
                "Oopsie daisy, [NEMESIS], looks like I beat you to the punchline. No spellcasting for them!",
                "Step aside, [NEMESIS], the master of interrupts has arrived. You can thank me later!",
                "They say timing is everything, [NEMESIS], and clearly, you're lacking in that department.",
                "Nice try, [NEMESIS], but interrupting spells is not your forte. Stick to what you're good at... which is... umm...",
                "Did you just yawn, [NEMESIS]? No worries, I'll keep the enemies from casting anything interesting.",
                "Hold on a moment, [NEMESIS], let me demonstrate how a true interrupter handles business.",
                "Hey, [NEMESIS], I bet you wish you could interrupt spells as gracefully as I do!",
                "Sorry, [NEMESIS], I didn't realize I was playing with a spectator instead of a participant.",
                "In the game of interrupts, you win some, you lose some, and you, [NEMESIS], lose them all.",
                "Who needs a mage to counter spell when I'm here, [NEMESIS]? I'm the hero you never knew you needed!",
                "Did you see that, [NEMESIS]? It's called an interrupt, and it's not just a fancy word.",
                "Oh, look, [NEMESIS], I just saved the day with my spell-breaking prowess. Again.",
                "Did someone forget to equip their interrupt ability, [NEMESIS]? It's a shame, really.",
                "You know, [NEMESIS], interrupting spells is kind of like breathing for me. So effortless.",
                "Don't worry, [NEMESIS], I'll handle the interrupting. You can stick to... well, whatever you're doing.",
                "I'm like a spellcasting nightmare for these enemies, [NEMESIS]. And you're... like a lullaby.",
                "Hey, [NEMESIS], next time, maybe you should focus on interrupting spells instead of daydreaming.",
                "No need to thank me, [NEMESIS]. I know my interrupting skills are awe-inspiring.",
                "I'm the disruptor of spells, [NEMESIS], and you're the bystander watching it happen.",
                "Interruptions are my specialty, [NEMESIS]. Looks like you're still working on yours.",
                "If spell interrupting were a sport, [NEMESIS], you'd be sitting on the bench.",
                "Impressive, [NEMESIS]. You managed to blink just in time to miss the spell interrupt.",
                "You can rely on me, [NEMESIS], to save the day with my impeccable timing. I'm practically a hero!",
                "Quick reflexes and impeccable timing, that's what sets me apart, [NEMESIS]. Well, that and my stunning good looks."
            },
            ["NEMESIS"] = {
                "Well, well, look who finally decided to show up, [NEMESIS]. You interrupted a spell? Color me impressed!",
                "Oh, [NEMESIS], did you manage to interrupt a spell all on your own? I guess even blind squirrels find acorns sometimes.",
                "I must have been too busy carrying the whole group while you stumbled upon an interrupt, [NEMESIS]. Good for you!",
                "Congratulations, [NEMESIS], you interrupted a spell. I was too busy saving the day to notice, but good job, I guess.",
                "Oh, how cute, [NEMESIS] interrupted a spell. You're like a little puppy nipping at the enemy's heels.",
                "Wait, what? [NEMESIS] interrupted a spell? I thought you were still playing hide-and-seek with the trash mobs!",
                "Well, look who finally woke up from their nap, [NEMESIS]. You interrupted a spell while the rest of us did all the heavy lifting!",
                "Oh, did someone accidentally press the interrupt button, [NEMESIS]? It's like witnessing a miracle!",
                "I didn't realize we had a hero in our midst, [NEMESIS]. Interrupting spells while the rest of us do the real work.",
                "Hold on, let me grab my magnifying glass. Ah, there it is! [NEMESIS] interrupting a spell. I almost missed it.",
                "Well, look who found their way out of the shadow of irrelevance, [NEMESIS]. You interrupted a spell. Bravo!",
                "Hey, [NEMESIS], did you interrupt a spell while daydreaming about getting carried through the dungeon? Good for you!",
                "Oh, [NEMESIS], you interrupted a spell? I was too busy being a one-person wrecking crew to notice your feeble contribution.",
                "Did someone just tap [NEMESIS] on the shoulder and tell them, 'Hey, you're in a dungeon, maybe try to interrupt something'? Good job, I guess.",
                "News flash, everyone! [NEMESIS] managed to interrupt a spell! I'm sure the world is quaking in awe.",
                "Hold on, let me get my binoculars. Ah, yes, there it is! [NEMESIS] interrupting a spell. My, how impressive.",
                "Oh, look, [NEMESIS] interrupted a spell! It's like watching a snail outrun a turtle.",
                "Bravo, [NEMESIS]! You interrupted a spell! Now if only you could interrupt my eye roll as well.",
                "Everyone, gather 'round! [NEMESIS] interrupted a spell! Let's give them a round of lukewarm applause.",
                "Well, I must have missed the memo about [NEMESIS] becoming the designated spell interrupter. Color me surprised!",
                "Did the stars align, [NEMESIS]? You actually managed to interrupt a spell. It's a rare sight to behold!",
                "Oh, look who stumbled upon an interrupt, [NEMESIS]. It's like watching a toddler accidentally press the right button on a toy.",
                "Wait, [NEMESIS] interrupted a spell? I guess even broken clocks are right twice a day.",
                "Well, well, look who decided to contribute, [NEMESIS]. You interrupted a spell while the rest of us were doing the real work.",
                "Attention, everyone! [NEMESIS] just interrupted a spell! It's a momentous occasion that will go down in... mediocrity.",
                "Hold the presses! [NEMESIS] managed to interrupt a spell. I hope they didn't strain themselves too much.",
                "Did someone cast a spell of competence on [NEMESIS]? They actually interrupted something! Miracles do happen!",
                "Ladies and gentlemen, prepare to be amazed! [NEMESIS] has successfully interrupted a spell! I'm in awe... or maybe it's just disbelief.",
                "Oh, did I miss something? [NEMESIS] interrupted a spell? Well, I suppose even a broken clock is right once in a blue moon.",
                "Attention, adventurers! [NEMESIS] has interrupted a spell! Don't worry, I'll try not to be too overwhelmed by their extraordinary achievement.",
                "Hold on a second, [NEMESIS] interrupted a spell? I thought I felt a disturbance in the force, but I must have been mistaken.",
                "Well, look who finally joined the party, [NEMESIS]. You interrupted a spell while the rest of us were wondering if you were even here!",
                "Ah, [NEMESIS], you interrupted a spell! I was starting to think you were just a myth, like the Loch Ness Monster or competent tanking.",
                "Did someone cast a spell of usefulness on [NEMESIS]? They actually managed to interrupt something. I'm in shock!",
                "Hold the phone, [NEMESIS] interrupted a spell? It's like witnessing a miracle unfold before our very eyes.",
                "Alert the press! [NEMESIS] interrupted a spell! I hope they brought their autograph book for all the adoring fans.",
                "Oh, look who woke up from their beauty sleep, [NEMESIS]. You interrupted a spell while the rest of us were busy carrying you.",
                "Did I miss the part where [NEMESIS] became the designated spell interrupter? I must have been too busy being awesome.",
                "Brace yourselves, everyone! [NEMESIS] interrupted a spell! Don't worry, I'm sure it won't go to their head... or maybe it already has.",
                "Well, well, [NEMESIS] interrupted a spell! It's like watching a turtle outrun a snail. Slow and steady wins the race, right?",
                "Hold onto your hats, folks! [NEMESIS] just interrupted a spell. The world will never be the same again... or maybe it will.",
                "Did someone forget to tell [NEMESIS] that interrupting spells is part of the job? Better late than never, I suppose.",
                "Oh, [NEMESIS], you interrupted a spell? I was starting to think you were allergic to being helpful.",
                "Well, look who finally decided to lend a hand, [NEMESIS]. You interrupted a spell while the rest of us were doing all the heavy lifting.",
                "Attention, everyone! [NEMESIS] interrupted a spell! Let's hope it's not just a fluke and they can do it again.",
                "Did the stars align, [NEMESIS]? You managed to interrupt a spell. It's a rare sight to behold, like a double rainbow or a sane gnome.",
                "Hold your applause, folks! [NEMESIS] interrupted a spell. Let's see if they can keep up the streak... or if it was just dumb luck."
            },
        },
        ["FEAST"] = {
            ["SELF"] = {
                "Looks like [NEMESIS] forgot to bring a [SPELL] for the group. No worries, we'll just have to rely on our own contributions, as usual.",
                "I've set up a [SPELL] to ensure everyone gets a much-needed boost. It seems [NEMESIS]'s largest contribution to the group might have been remembering to join.",
                "Don't worry, I've taken care of the [SPELL] for the team. We'll have to make due without [NEMESIS]'s culinary \"skills\" this time.",
                "Behold, a delicious [SPELL] for the group! If only [NEMESIS] had graced us with their culinary expertise, it could have been their greatest contribution yet.",
                "Feast your eyes on the [SPELL] I've prepared. It seems [NEMESIS] missed the memo on teamwork, but we'll manage without their banquet, won't we?",
                "A tasty [SPELL] awaits us all. Too bad [NEMESIS] didn't think of providing one. It could have been their shining moment of group contribution.",
                "Ladies and gentlemen, I present to you a delectable [SPELL] for our enjoyment. Let's savor the flavor of teamwork, even if [NEMESIS] forgot to bring their recipe.",
                "I've taken the initiative to set up a mouthwatering [SPELL] for the group. It seems [NEMESIS] couldn't find their way to the kitchen, but we'll manage just fine.",
                "Feast time! I've got the [SPELL] covered, so we can all enjoy the benefits. Too bad [NEMESIS] missed the chance to show off their culinary skills.",
                "Attention, everyone! A sumptuous [SPELL] has been prepared to boost our performance. Let's make the most of it, despite [NEMESIS]'s culinary negligence.",
                "Good news, everyone! The [SPELL] is ready to be devoured. It's a shame [NEMESIS] missed the opportunity to contribute in a truly meaningful way.",
                "Let the feast begin! I've set up a delightful [SPELL] for the group. Sadly, [NEMESIS] won't be known for their culinary prowess in this adventure.",
                "Great news, fellow adventurers! The [SPELL] is here to fuel our success. I suppose we'll have to forgive [NEMESIS] for their lack of culinary ambition.",
                "Prepare to indulge in the deliciousness of the [SPELL] I've arranged. We'll have to rely on our own taste buds, since [NEMESIS] didn't bring anything to the table.",
                "Attention, everyone! A mouthwatering [SPELL] has been prepared to enhance our performance. It's a pity [NEMESIS] missed their chance to shine as a master chef.",
                "I've got a surprise for you all—a fantastic [SPELL] to boost our prowess. Too bad [NEMESIS] missed the memo on group contributions. Bon appétit!",
            },
            ["NEMESIS"] = {
                "Well, would you look at that! [NEMESIS] managed to contribute something after all. A [SPELL]. I guess it'll go down in history as their greatest achievement in this group.",
                "Hold your applause, folks! [NEMESIS] has graced us with their culinary skills and placed a [SPELL]. It might just be their most memorable contribution to the team.",
                "In a shocking turn of events, [NEMESIS] has actually done something useful. They provided a [SPELL]. It's a small victory for them in the grand scheme of teamwork.",
                "I must admit, I'm pleasantly surprised. [NEMESIS] remembered to bring a [SPELL]. It's a glimmer of hope that they might contribute something meaningful to the group.",
                "Stop the presses! [NEMESIS] has stepped up and provided a [SPELL]. It's a monumental occasion and will forever be remembered as their crowning achievement.",
                "Well, well, well. [NEMESIS] managed to accomplish something significant. They placed a [SPELL]. It's a shining beacon of their contribution to this illustrious team.",
                "I'll be damned! [NEMESIS] has gone above and beyond expectations by setting up a [SPELL]. It's an extraordinary event that will be etched in our memories forever.",
                "Hold onto your hats, everyone! [NEMESIS] has exceeded all expectations by presenting a [SPELL]. It's a remarkable feat for someone of their caliber.",
                "Breaking news: [NEMESIS] has done the unthinkable and placed a [SPELL]. It's a miraculous display of their commitment to the team, or perhaps just blind luck.",
                "Mark this day on your calendars, folks! [NEMESIS] has risen to the occasion and provided a [SPELL]. It will forever be remembered as their magnum opus.",
                "I never thought I'd live to see the day, but [NEMESIS] has come through with a [SPELL]. It's a watershed moment and their greatest contribution to the group so far.",
                "Hold onto your seats, everyone! [NEMESIS] has performed a minor miracle and placed a [SPELL]. It's an awe-inspiring achievement for someone of their caliber.",
                "Unbelievable! [NEMESIS] has defied all odds and graced us with a [SPELL]. It's a testament to their newfound commitment, or maybe they just stumbled upon it.",
                "Well, what do you know? [NEMESIS] has made their mark by providing a [SPELL]. It's a commendable effort and their most noteworthy contribution to the team.",
                "It seems the impossible has happened! [NEMESIS] has contributed something substantial—a [SPELL]. It's their crowning glory and a remarkable display of team spirit.",
                "Stop the presses! [NEMESIS] has shocked us all by placing a [SPELL]. It's a pivotal moment in their journey with the group and their defining act of generosity.",
            },
        },
        ["OLDFEAST"] = {
            ["SELF"] = {
                "Hey, [NEMESIS], I've got a special treat for you! Feast your eyes on this vintage feast from a bygone era. It's a perfect match for your outdated gameplay.",
                "Don't worry, [NEMESIS], I've prepared a feast just for you. It's a relic from a previous expansion, much like your understanding of current game mechanics.",
                "Look what I have for you, [NEMESIS]! It's a feast from a time long past, just like your relevance in the modern gaming world. Enjoy!",
                "I thought you might appreciate this, [NEMESIS]. I've set out an ancient feast that perfectly complements your archaic playstyle. Bon appétit!",
                "Feast your heart out, [NEMESIS], on this relic from yesteryears. It's a feast fit for a player stuck in the past, just like you!",
                "Hey, [NEMESIS], I brought a little something for you. It's a feast from an ancient age, just like your knowledge of current game mechanics. Enjoy your trip down memory lane!",
                "Behold, [NEMESIS], a feast straight from the annals of history. It's the perfect match for your outdated strategies and relics of a bygone era.",
                "I've set up a special feast for you, [NEMESIS]. It's a blast from the past, much like your understanding of modern raid encounters. Enjoy your trip down nostalgia lane!",
                "Hey, [NEMESIS], I've got a surprise for you. I've laid out a feast from a previous expansion, so you can indulge in your retro gaming experience while the rest of us enjoy the present.",
                "Special delivery for [NEMESIS]! I've set up a feast from a different era, just like your ancient tactics. Consider it a time capsule of your gameplay!",
                "Attention, everyone! [NEMESIS] gets the honor of feasting on this relic from the past. It's a symbol of their dedication to outdated strategies and old-school failure.",
                "I've got a special treat for you, [NEMESIS]. Feast your eyes on this vintage banquet, perfectly suited for someone stuck in the past. Enjoy your meal, relic of irrelevance!",
                "Hey, [NEMESIS], I've set out a feast from an era long gone. It's a reminder of the glory days when your gameplay actually mattered. Dig in and reminisce!",
                "Behold, [NEMESIS], a feast from an ancient expansion. It's a testament to your resistance to change and your preference for mediocrity. Enjoy the taste of irrelevance!",
                "I've prepared something special for you, [NEMESIS]. Indulge in this feast from a forgotten time, just like your chances of ever catching up with the current game meta.",
                "Feast your eyes, [NEMESIS], on this culinary relic from the past. It's a reflection of your refusal to adapt and embrace the present. Enjoy your taste of obsolescence!",
            },
            ["NEMESIS"] = {
                "Oh, look what we have here, [NEMESIS] brought us a feast straight out of a museum. Nothing says 'contributing to the group' like an outdated meal.",
                "Well, well, well, [NEMESIS] has outdone themselves this time. They managed to dig up a relic of a feast that perfectly matches their outdated gameplay. How... thoughtful.",
                "Hold your excitement, everyone, [NEMESIS] has graced us with their contribution to the feast. I hope you all enjoy this taste of irrelevance.",
                "Prepare yourselves, folks, [NEMESIS] has generously provided us with a feast from an ancient era. It's a symbol of their resistance to progress and their commitment to being a burden.",
                "Oh, joy! [NEMESIS] has bestowed upon us their culinary masterpiece from a bygone era. I can't think of a better way to celebrate their complete lack of understanding.",
                "Brace yourselves, team, [NEMESIS] has kindly offered us a feast from a time when dinosaurs roamed the earth. It's the perfect accompaniment to their extinct knowledge and abilities.",
                "Hold onto your seats, everyone, [NEMESIS] has unveiled their contribution to the feast. It's a testament to their knack for bringing outdated relics to the table, both literally and figuratively.",
                "I'm speechless, [NEMESIS]. You've managed to astound us all with your extraordinary ability to find the most archaic feast in existence. Bravo.",
                "Step right up, folks, and witness the marvel that is [NEMESIS]'s contribution to the feast. It's a true testament to their unmatched talent for unearthing culinary fossils.",
                "Well, isn't this a delightful surprise? [NEMESIS] has gifted us with a feast that predates the discovery of fire. It's a taste of prehistoric incompetence.",
                "Hold your applause, everyone, as we gaze upon [NEMESIS]'s grand offering. It's a feast so ancient, it makes their gameplay look modern in comparison.",
                "Incredible! [NEMESIS] has treated us to a feast from the dark depths of gaming history. It's a remarkable display of their ability to find the most obsolete items available.",
                "Prepare your taste buds, team, because [NEMESIS] has unveiled their contribution to the feast. It's like taking a trip back in time, to a place where terrible gameplay was the norm.",
                "Well, well, well, what do we have here? [NEMESIS] has decided to grace us with their expertise in ancient feasting. It's a true culinary relic, just like their skills.",
                "Ladies and gentlemen, behold the feast that [NEMESIS] has presented to us. It's a delightful throwback to a time when their gameplay was equally disappointing.",
                "Marvel at [NEMESIS]'s extraordinary find, a feast from an era so ancient, it predates the very concept of taste. Truly, their commitment to mediocrity knows no bounds.",
            },
        },
        ["REFEAST"] = {
            ["SELF"] = {
                "Oh, look at that, [NEMESIS], I placed a feast right after someone else did. I knew you needed a backup option for when your incompetence inevitably ruins the first one.",
                "Well, well, well, what do we have here? I just happened to place a feast right after someone else did. It's like the universe knew we needed a contingency plan for [NEMESIS]'s questionable decision-making.",
                "How convenient, [NEMESIS], I just put down a feast right after someone else did. It's almost as if the group sensed your ability to mess things up and wanted to ensure we have something edible.",
                "Just in case, [NEMESIS], I've placed a feast right after someone else did. Consider it a safety net for when you inevitably make a mess of things. You're welcome.",
                "Oh, what perfect timing! I've set up a feast right after someone else did. It's like they knew we needed a Plan B for when [NEMSIS] inevitably botches the first one. Enjoy!",
                "You won't believe this, [NEMESIS], I've laid out a feast right after someone else did. It's almost as if they anticipated your special talent for turning feasting into a catastrophe.",
                "Well, isn't this interesting? I just set up a feast right after someone else did. It's like the group sensed [NEMESIS]'s tendency to ruin things and decided to take matters into their own hands.",
                "Surprise, [NEMESIS], I've placed a feast right after someone else did. It's as if they knew we needed a fallback option in case your incompetence caused the first one to go awry.",
                "I couldn't resist, [NEMESIS]. I set up a feast right after someone else did. It's like a safety measure for when your unique ability to ruin everything kicks in. Bon appétit!",
                "How considerate of me, [NEMESIS]. I've prepared a feast right after someone else did. It's to ensure we have a backup plan in case your ineptitude leads to a feast-related disaster.",
                "Well, well, well, look what we have here. I've arranged a feast right after someone else did. It's almost as if they knew we needed an extra feast to compensate for [NEMESIS]'s potential mishaps.",
                "I thought I'd be proactive, [NEMESIS], and set up a feast right after someone else did. It's like a preemptive measure for when your involvement threatens to turn the first feast into a disaster.",
                "Behold, [NEMESIS], a feast right after someone else placed theirs. It's as if they sensed your knack for causing chaos and wanted to make sure we have something edible.",
                "In a stroke of genius, I've set up a feast right after someone else did. It's like a contingency plan for when [NEMESIS]'s special talent for mishaps comes into play. Enjoy, if you can!",
                "I couldn't resist the opportunity, [NEMESIS]. I placed a feast right after someone else did. It's like they knew we needed an alternative when your involvement jeopardizes the first one.",
                "Oh, the timing is just impeccable! I've prepared a feast right after someone else did. It's like the universe wants to ensure we have a backup plan for when [NEMESIS]'s chaos-making tendencies kick in.",
                "I hope you appreciate this, [NEMESIS]. I've arranged a feast right after someone else did. It's a safety measure for when your track record threatens to turn the first feast into a disaster.",
            },
            ["NEMESIS"] = {
                "Well, look who finally decided to make a contribution! [NEMESIS] has placed a feast after someone else already did. Trying to save face, are we?",
                "Oh, how generous of you, [NEMESIS]! Placing a feast after someone else already did. It's your attempt to show that you can contribute, even if it's just a feeble attempt.",
                "Just when I thought miracles don't happen, [NEMESIS] steps in with their grand gesture of placing a feast after someone else already did. Trying to make up for lost time, are we?",
                "Ah, the pinnacle of selflessness! [NEMESIS] places a feast after someone else already did. I suppose we should applaud their valiant effort to contribute, even if it's a bit too late.",
                "Well, well, look who finally decided to join the party! [NEMESIS] places a feast after someone else already did. Guess they couldn't resist the urge to make it all about them.",
                "Hold your applause, everyone! [NEMESIS] has made their grand entrance by placing a feast after someone else already did. A true master of timing, or just desperate for attention?",
                "Look, everyone, [NEMESIS] has graced us with their generosity! They placed a feast after someone else already did. It's their way of saying, 'Hey, I can contribute too!' How touching.",
                "Brace yourselves, folks! [NEMESIS] has made a monumental contribution by placing a feast after someone else already did. I guess we should be grateful for their belated attempt to help.",
                "Oh, the hero we never asked for! [NEMESIS] swoops in with their feast after someone else already did. Their selflessness knows no bounds, or maybe they just want a piece of the spotlight.",
                "Attention, everyone! [NEMESIS] has made an earth-shattering move by placing a feast after someone else already did. Their dedication to being fashionably late knows no bounds.",
                "We can all rest easy now! [NEMESIS] has graced us with their presence by placing a feast after someone else already did. It's their grand gesture of saying, 'Look at me, I'm contributing!'",
                "Hold onto your seats, folks! [NEMESIS] has just revolutionized the art of contribution by placing a feast after someone else already did. A true innovator, or just desperately seeking validation?",
                "Stop the presses! [NEMESIS] has taken the world by storm with their daring move of placing a feast after someone else already did. It's a shining example of their unparalleled ability to follow trends.",
                "Breaking news, everyone! [NEMESIS] has made headlines with their groundbreaking act of placing a feast after someone else already did. A true visionary, or just trying to avoid being left out?",
                "I hope you're all ready for a feast of epic proportions! [NEMESIS] has graced us with their culinary skills by placing one after someone else already did. It's a display of their unmatched self-importance.",
                "Prepare yourselves for a feast experience like no other! [NEMESIS] has entered the scene with their feast, right after someone else already did. It's their way of reminding us that they too can contribute... eventually.",
            }
        }
    },
    ["GROUP"] = {
        ["JOIN"] = {
            ["SELF"] = {
                "Oh, my apologies, everyone. It seems we have the pleasure of [NEMESIS]'s company. I can't help but wonder what poor life choices led to this moment.",
                "Well, well, well, look who we have here. It's [NEMESIS], the shining beacon of disappointment. I can only assume someone lost a bet to end up in the same group as them.",
                "Hold onto your sanity, folks, because we have the honor of having [NEMESIS] amongst us. I hope you're all prepared for a masterclass in frustration and regret.",
                "Ladies and gentlemen, prepare yourselves for a truly mind-boggling experience. [NEMESIS] has graced us with their presence. I can't help but question the sanity of the person who invited them.",
                "Attention, adventurers! Brace yourselves for the most shocking revelation of the day: [NEMESIS] is here. I can only hope their performance matches our already diminished expectations.",
                "Well, I must say, I wasn't expecting this level of disappointment today. [NEMESIS] has joined our group, and I find myself questioning the meaning of life.",
                "Hold the presses, everyone! We have a special guest with us today, none other than [NEMESIS]. I'm genuinely curious as to why anyone would willingly subject themselves to such agony.",
                "I'm not sure if I should be horrified or amused, but [NEMESIS] has managed to infiltrate our group. I suppose there's a lesson in every tragedy, though I'm not sure what it is.",
                "Prepare yourselves for a wild ride, my friends, because we have the one and only [NEMESIS] in our group. It's a bold choice, to say the least.",
                "Well, it appears the stars have aligned in the most unfortunate way possible. We find ourselves in the dubious presence of [NEMESIS]. I hope you've all said your prayers.",
                "Attention, everyone! We have a surprise guest joining us today, and it's none other than [NEMESIS]. I have so many questions, but I fear the answers may only lead to more despair.",
                "Hold onto your hopes and dreams, adventurers, because [NEMESIS] has joined our merry band. I'm not sure if I should be impressed by their audacity or concerned for their mental well-being.",
                "Well, isn't this a delightful turn of events? [NEMESIS] has graced us with their presence. I can only hope they bring more than just disappointment to the table.",
                "Ah, the wonders of fate. We find ourselves in the company of [NEMESIS], a shining example of how not to succeed. I'm both horrified and strangely fascinated.",
                "Ladies and gentlemen, put your hands together for our newest addition, [NEMESIS]. It takes a special kind of bravery to willingly invite them into our group.",
                "Well, I must admit, I didn't expect to encounter [NEMESIS] in my adventures today. But here we are, facing the harsh reality of their presence. May the odds be ever in our favor.",
                "Hold onto your sanity, my friends, because we have the pleasure of [NEMESIS]'s company. I hope you've all brought your patience and understanding.",
                "Well, well, well, what do we have here? It seems we have the honor of sharing our journey with none other than [NEMESIS]. I can already feel the disappointment settling in.",
                "Attention, adventurers! Take a good look around, because you're about to witness a rare sight. Yes, indeed, [NEMESIS] has managed to find their way into our group.",
                "Prepare yourselves for a shock, everyone. [NEMESIS] has infiltrated our ranks, and I can't help but wonder if this is some kind of twisted social experiment.",
                "Hold onto your hopes, because they're about to be dashed to pieces. [NEMESIS] is here, and I can't fathom why anyone would subject themselves to such torment.",
                "Ah, the universe works in mysterious ways. We find ourselves in the unfortunate position of being accompanied by [NEMESIS]. I can only hope we survive this ordeal.",
                "Well, isn't this a delightful surprise? [NEMESIS] has decided to grace us with their presence. Brace yourselves for a bumpy ride.",
                "Attention, everyone! It seems we have a special guest today, and it's none other than [NEMESIS]. I hope you're all ready for a test of your resilience.",
                "Hold onto your dreams, adventurers, because [NEMESIS] is here to crush them. I can't help but question the wisdom of allowing them to join our group.",
                "Oh, dear, it seems we've been blessed with [NEMESIS]'s company. I hope you've all made peace with the fact that success is no longer an option.",
                "Well, I never thought I'd see the day, but here we are. [NEMESIS] has become an integral part of our group. May the forces of luck be with us.",
                "Prepare yourselves, everyone, for the arrival of [NEMESIS]. I can't help but wonder if they'll exceed our wildest expectations... or simply confirm our worst fears.",
                "Ah, the joys of destiny. We find ourselves united with [NEMESIS], the bringer of disappointment. I can't decide if I should laugh or cry.",
                "Ladies and gentlemen, gather 'round, for we have a newcomer in our midst. Give a warm welcome to [NEMESIS], the personification of shattered dreams.",
                "Well, well, well, what have we here? It seems we've won the lottery of misfortune with the addition of [NEMESIS] to our group.",
                "Attention, adventurers! Prepare yourselves for a rollercoaster of emotions, as [NEMESIS] has decided to bless us with their presence. Let the fun begin.",
                "Hold onto your wits, everyone, because [NEMESIS] has joined our expedition. I hope you've all packed your sense of humor, because we're going to need it.",
                "Well, well, well, it seems we have an unexpected guest. Please welcome [NEMESIS], the one who defies all logic and reasoning.",
                "Attention, adventurers! I regret to inform you that [NEMESIS] has been added to our party. Let's hope for the best and prepare for the worst.",
                "Hold onto your illusions of success, my friends, because [NEMESIS] has arrived. I hope you've all come to terms with the concept of carrying.",
                "Ah, the irony of fate. We find ourselves in the company of [NEMESIS], the living embodiment of disappointment. Brace yourselves for an unforgettable experience.",
            },
            ["NEMESIS"] = {
                "Oh, look who decided to grace us with their presence, [NEMESIS]. I hope you're ready to be carried like a sack of potatoes.",
                "Well, well, if it isn't the prodigal [NEMESIS] returning to bless us with their questionable skills. Try not to get in the way.",
                "Great, [NEMESIS] has joined the group. I can already feel my enthusiasm plummeting faster than a goblin's moral compass.",
                "Hold on, let me prepare my eyerolls for [NEMESIS]'s grand entrance. I hope you're not planning to contribute anything useful.",
                "Oh, joy! [NEMESIS] has arrived to enlighten us with their special brand of incompetence. Can't wait to see what disaster awaits.",
                "Look who's here, everyone! It's [NEMESIS], the personification of disappointment. Brace yourselves for subpar performance.",
                "Ah, the hero we never asked for, [NEMESIS], has joined the group. Don't worry, we'll manage despite your best efforts.",
                "Oh, dear, it seems we've been graced with [NEMESIS]'s presence. Try not to mess things up too much, if you can help it.",
                "Well, look who dragged themselves out of the gutter and into our group, [NEMESIS]. Don't expect any miracles from us to compensate for your lack of skill.",
                "Welcome, [NEMESIS], to the illustrious ranks of mediocrity. You're in good company with the rest of us struggling to carry the team.",
                "Oh, joy of joys! [NEMESIS] has arrived to bless us with their astonishing ability to underperform. Try not to bring us down too much.",
                "Hold onto your hats, folks, [NEMESIS] is here to make everything just a little bit worse. Don't worry, we'll manage to survive... barely.",
                "Well, look who's decided to grace us with their presence, [NEMESIS]. I hope you brought your best excuses for why you can't pull your weight.",
                "Ah, [NEMESIS], the harbinger of disappointment, has arrived. Brace yourselves for a masterclass in how not to play the game.",
                "Oh, fantastic! [NEMESIS] has joined the group. Now we can experience the thrill of frustration and the joy of carrying.",
                "Welcome, [NEMESIS], to the group where dreams come to die. Don't worry, we'll make sure your dreams of competence are crushed in no time.",
                "Look who crawled out from under their rock, [NEMESIS]. Brace yourselves for a performance that will make us all question our life choices.",
                "Well, isn't this a delightful surprise? [NEMESIS] has arrived, and I can already feel the weight of their incompetence dragging us down.",
                "Hold your applause, everyone, [NEMESIS] has joined the group. Now we can witness firsthand what it means to be utterly useless.",
                "Oh, lucky us! [NEMESIS] has graced us with their presence. I hope you're ready to be carried on a platter of disappointment.",
                "And here we have [NEMESIS], the shining example of how not to play the game. Prepare for a masterclass in failure.",
                "Oh, look who's here, it's [NEMESIS]! I hope you brought your excuses, because you're going to need them.",
                "Ah, [NEMESIS], the legend in their own mind, has arrived. Brace yourselves for an exhibition of inflated ego and lackluster performance.",
                "Welcome, [NEMESIS], to the group where competence goes to die. Don't worry, we'll bury your hopes of success alongside ours.",
                "Hold onto your sanity, folks, [NEMESIS] is here to test your limits. Prepare for frustration and disbelief in equal measure.",
                "Well, well, if it isn't the personification of disappointment, [NEMESIS]. I hope you're ready for a crash course in how not to contribute.",
                "Oh, look who stumbled into the dungeon, it's [NEMESIS]. Prepare for an adventure in carrying someone who can't carry their own weight.",
                "Ah, the epitome of underachievement, [NEMESIS], has arrived. Brace yourselves for a symphony of mistakes and missed opportunities.",
                "Welcome to the group, [NEMESIS]. We've been eagerly awaiting the chance to witness your remarkable ability to disappoint.",
                "Hold your breath, everyone, [NEMESIS] is here. It's like watching a train wreck in slow motion, but with less entertainment value.",
                "Well, what do we have here? It's [NEMESIS], the personification of mediocrity. Prepare for a performance that will leave us all unimpressed.",
                "Oh, fantastic! [NEMESIS] has graced us with their presence. I hope you're ready to be carried through this dungeon like dead weight.",
                "Attention, everyone! [NEMESIS] has joined the group. Get ready for a rollercoaster ride of frustration, disappointment, and regret.",
                "Look who's back, [NEMESIS]. I hope you've been honing your skills in the art of underperforming, because we have high expectations.",
                "Ah, [NEMESIS], the master of inconvenience, has arrived. Prepare for a journey filled with unnecessary complications and facepalms.",
                "Welcome, [NEMESIS], to the group where dreams of success are shattered. I hope you're ready for a reality check.",
            },
            ["BYSTANDER"] = {
                "Oh, [BYSTANDER], you poor soul, heed my warning: [NEMESIS] is amongst us. May the gaming gods have mercy on your sanity.",
                "Listen closely, [BYSTANDER], for I have news that will chill your spine. [NEMESIS] is a member of this group, and their ability to disappoint knows no bounds.",
                "Ah, [BYSTANDER], prepare yourself for a most peculiar experience. You have the dubious honor of joining a group that includes [NEMESIS], a true legend in their own mind.",
                "Brace yourself, [BYSTANDER], for you are about to face a formidable challenge. You will have the pleasure of witnessing firsthand the performance of [NEMESIS]. Good luck, my friend.",
                "Attention, [BYSTANDER], gather 'round and listen well. You have entered a realm where [NEMESIS] roams free, and their presence may test your patience like never before.",
                "Welcome, [BYSTANDER], to a group that is about to embark on an extraordinary journey. But be warned, within our ranks lies [NEMESIS], a force of underachievement and frustration.",
                "Oh, dear [BYSTANDER], fate has brought you here, but it has also brought [NEMESIS] to our group. I can only hope you possess nerves of steel and a spirit that refuses to be crushed.",
                "Take a deep breath, [BYSTANDER], for you are about to witness a spectacle unlike any other. [NEMESIS], the embodiment of disappointment, walks among us.",
                "Listen closely, [BYSTANDER], for I have a tale to tell. In this group, we have [NEMESIS], a player whose performance will challenge your every expectation. May you emerge unscathed.",
                "Oh, [BYSTANDER], consider this a friendly warning: you have entered the domain of [NEMESIS]. Prepare yourself for a journey filled with disbelief and frustration.",
                "Attention, [BYSTANDER], I feel obligated to inform you of a grave truth. [NEMESIS], the bringer of shattered dreams, is here. Proceed with caution.",
                "Oh, [BYSTANDER], I wish I could spare you from what lies ahead. Alas, you must face the reality that [NEMESIS] is part of our group. Stay strong, my friend.",
                "Welcome, [BYSTANDER], to a group where the extraordinary becomes ordinary. Brace yourself for encounters with [NEMESIS], a player who defies all expectations... in the worst possible way.",
                "Hold onto your hope, [BYSTANDER], for you have entered a realm tainted by the presence of [NEMESIS]. May you find the strength to endure their unique brand of gameplay.",
                "Attention, [BYSTANDER], take a moment to contemplate your decision. You have willingly joined a group that includes [NEMESIS], a player whose performance will test your patience to its limits.",
                "Oh, [BYSTANDER], I regret to inform you that your journey has led you to a group that harbors [NEMESIS]. May you find solace in the knowledge that you are not alone in this struggle.",
                "Listen closely, [BYSTANDER], for I have news that may make your heart skip a beat. [NEMESIS], a legend in their own mind, walks among us. May your fortitude be unwavering.",
                "Welcome, [BYSTANDER], to a group where the line between comedy and tragedy is blurred. Brace yourself for the enigma that is [NEMESIS].",
                "Oh, [BYSTANDER], you know not what you've stepped into. This group is haunted by the presence of [NEMESIS], a player who defies all expectations... in the worst possible way.",
                "Attention, [BYSTANDER], prepare yourself for a grand spectacle. Our group includes the one and only [NEMESIS], whose performance will leave you questioning the nature of reality.",
                "Oh, [BYSTANDER], what cruel fate has brought you here? Within this group lurks [NEMESIS], whose presence may make you question the very fabric of your gaming existence.",
                "Oh, [BYSTANDER], welcome to the circus! You'll be delighted to know that [NEMESIS] has acquired their account, complete with zero knowledge of how to play their character. Enjoy the show!",
                "Attention, [BYSTANDER], prepare for a masterclass in confusion. [NEMESIS], the proud owner of a purchased account, will dazzle you with their complete lack of understanding of their own class.",
                "Listen closely, [BYSTANDER], for I have a tale of hilarity to share. [NEMESIS] has found their way into this group through the art of account purchasing. May their bewildering actions bring you joy.",
                "Oh, [BYSTANDER], brace yourself for an experience like no other. [NEMESIS], the proud owner of a pre-owned account, will demonstrate their complete incompetence with their character. It's truly a sight to behold.",
                "Welcome, [BYSTANDER], to a group that defies all logic. Among us is [NEMESIS], who, through the wonders of account purchasing, graces us with their bewildering attempts at playing their character.",
                "Hold onto your laughter, [BYSTANDER], for you are about to witness a performance of epic proportions. [NEMESIS], the proud owner of an acquired account, will baffle you with their utter cluelessness.",
                "Attention, [BYSTANDER], prepare to witness the tragicomedy of [NEMESIS]. Unbeknownst to them, their account was purchased, and their struggles to understand their character will leave you in stitches.",
                "Oh, [BYSTANDER], get ready for a spectacle that defies all expectations. [NEMESIS], the bewildered owner of a purchased account, will astound you with their complete lack of knowledge.",
                "Listen up, [BYSTANDER], for I have a tale of folly to tell. Our group has the distinct pleasure of welcoming [NEMESIS], who acquired their account and now stumbles through their character's abilities like a blindfolded gnome.",
                "Welcome, [BYSTANDER], to the theater of absurdity. [NEMESIS], the fortunate recipient of a purchased account, will leave you in awe with their absolute ineptitude in playing their own character.",
            }
        },
        ["LEAVE"] = {
            ["NEMESIS"] = {
                "Farewell, [NEMESIS]! The heavens have answered our prayers, and the group is finally free from the clutches of your incompetence. Rejoice, my friends, for our journey just got infinitely better.",
                "Oh, what a glorious day! [NEMESIS] has departed, and the sun shines brighter upon us. Let us revel in the joyous knowledge that our group is now blessed with their absence.",
                "Hallelujah! [NEMESIS] has left the building, and a wave of relief washes over us. We can finally venture forth without the burden of their presence. Rejoice!",
                "Oh, the sweet sound of victory! [NEMESIS] has abandoned our group, leaving behind a trail of grateful tears. Let us cherish this moment of liberation and march on to triumph.",
                "Good riddance, [NEMESIS]! Like a bad dream fading into the abyss, you have vanished from our group. The air is fresher, the skies bluer, and our chances of success infinitely higher.",
                "Rejoice, my fellow adventurers, for a dark cloud has been lifted. [NEMESIS] has bid us farewell, and the weight of their incompetence no longer drags us down. Onwards to glory!",
                "Sing, dance, and celebrate, for [NEMESIS] has departed! Their departure marks the dawning of a new era, where victory and progress can flourish unhindered. Let the merriment begin!",
                "Oh, what a marvelous turn of events! [NEMESIS] has vanished into the shadows, leaving behind a trail of relieved sighs. Our group can finally breathe and thrive without their presence.",
                "Behold, adventurers, for [NEMESIS] has taken their leave. Let us embrace this newfound freedom and bask in the glory of a group unburdened by their bewildering actions. Onward, my friends!",
                "Hear ye, hear ye! Let it be known that [NEMESIS] has departed, leaving behind a group unshackled from the chains of frustration. Rejoice, my comrades, for our future shines brighter without them.",
                "Victory is ours, for [NEMESIS] has retreated into the shadows! Let the echoes of our elation resound through these halls as we revel in the blissful absence of their presence.",
                "Oh, happy day! The heavens have granted us reprieve, and [NEMESIS] has exited the stage. Let us savor this moment and forge ahead with renewed determination.",
                "Cheers and applause fill the air as [NEMESIS] bids us farewell. Our group stands united in jubilation, grateful for the newfound peace and serenity that fills the void they leave behind.",
                "Rejoice, adventurers, for our salvation has arrived! [NEMESIS] has left the group, bestowing upon us the gift of liberation. Let us seize this opportunity and triumph over adversity.",
                "Raise your weapons high, for the time of deliverance is at hand! [NEMESIS] has departed, and the collective sigh of relief resonates within our hearts. Onwards, my comrades, to victory!",
                "Behold, fellow heroes, for the tyranny of [NEMESIS] is no more! Their departure marks a new chapter of triumph and accomplishment. Let us forge ahead, unencumbered by their ineptitude.",
                "The winds of change blow in our favor, for [NEMESIS] has made their exit. Rejoice, my friends, for our group is now free to soar to new heights of success and camaraderie.",
                "Oh, happy day! The burden of [NEMESIS] has been lifted, and our group can now thrive without their baffling presence. Let us revel in the newfound harmony and conquer the challenges that lie ahead.",
                "Cheers erupt as [NEMESIS] bids us farewell. The air is infused with relief and excitement, for we are finally free from their bewildering actions. Onward, my comrades, to a future filled with triumph!",
                "Rejoice, adventurers, for the storm has passed! [NEMESIS] has left, leaving behind a group united in gratitude. Let us seize this opportunity to conquer the dungeons with renewed vigor.",
                "Raise your glasses in celebration, for we have been granted deliverance from [NEMESIS]'s bumbling ways. Our group can now flourish and achieve greatness without their hindrance. Cheers to a brighter future!",
                "The sun shines brighter upon us as [NEMESIS] fades into oblivion. Our group is reinvigorated, liberated from the shackles of their ineptitude. Let us march forward with confidence and triumph.",
                "Oh, what a relief! The departure of [NEMESIS] brings forth a wave of jubilation. We can now proceed with clarity and unity, leaving behind the chaos that once consumed us.",
                "Listen closely, fellow adventurers, for the winds of fortune have favored us. [NEMESIS] has departed, and with their absence comes a renewed sense of purpose and excitement. Let us seize this moment and conquer!",
                "Celebrate, my comrades, for the nightmare has ended. [NEMESIS] has left the group, and a collective sigh of relief echoes through our ranks. Together, we shall overcome any challenge that dares cross our path.",
                "Behold, the dawn of a new era! With [NEMESIS] gone, our group can finally flourish. Let the echoes of our gratitude resound through these halls as we embark on a journey of triumph and camaraderie.",
                "A collective cheer fills the air as [NEMESIS] retreats from our group. We stand tall, liberated from their bewildering gameplay. The future holds promise, and together we shall conquer all obstacles.",
                "The group breathes a sigh of relief as [NEMESIS] fades away. We are free from their incompetence, free to thrive and excel. Let us embrace this newfound freedom and march towards victory!",
                "Rejoice, adventurers, for the heavens have granted us reprieve. [NEMESIS] is no longer among us, and our spirits soar high with the weight of their absence lifted. Onward we march, towards glory!",
                "Oh, the joyous chorus of freedom! With [NEMESIS] gone, our group stands stronger than ever. Let the echoes of our triumph ring loud as we venture forth, unburdened and unstoppable.",
                "The departure of [NEMESIS] marks a turning point in our group's destiny. With their absence, we are revitalized, ready to conquer the challenges that lie ahead. Let victory be our anthem!",
                "Raise your voices in celebration, for we are liberated from the clutches of [NEMESIS]'s incompetence. The future shines bright, and our journey shall be filled with triumph and camaraderie.",
                "The skies clear, and a sense of relief washes over us as [NEMESIS] departs. No longer shall their bewildering actions hinder our progress. Let us embrace this newfound freedom and forge a path to glory!",
            },
            ["BYSTANDER"] = {
                "Look, everyone! [NEMESIS] was so atrocious that even [BYSTANDER] couldn't bear to witness their gameplay any longer. The mighty have fallen, indeed!",
                "Oh, the irony! [NEMESIS] was such a catastrophic force that even [BYSTANDER] has abandoned ship. It seems their tolerance for incompetence has reached its limit.",
                "Behold, the great exodus begins! [NEMESIS] was the catalyst that drove [BYSTANDER] away, like a plague that couldn't be endured any longer. May they find solace in greener pastures.",
                "Did you see that? [NEMESIS]'s gameplay was so abysmal that even [BYSTANDER] had to flee for their own sanity. The evidence is clear: the presence of [NEMESIS] is truly detrimental to any group.",
                "Well, well, well, what do we have here? [NEMESIS] managed to drive [BYSTANDER] away with their mind-boggling incompetence. It seems their reputation precedes them.",
                "The truth is undeniable: [NEMESIS] is so incredibly awful that even [BYSTANDER] had to make a hasty exit. Their gameplay is truly a force to be reckoned with... in all the wrong ways.",
                "Newsflash, everyone! [NEMESIS] was so dreadful that [BYSTANDER] couldn't bear to witness their gameplay any longer. The sheer level of ineptitude has driven them away.",
                "In a stunning turn of events, [NEMESIS] managed to push [BYSTANDER] to the breaking point. Their gameplay was so catastrophic that even the most patient player had to seek refuge elsewhere.",
                "Hold your laughter, folks! [NEMESIS] was such a spectacular disaster that even [BYSTANDER] couldn't handle their presence any longer. It takes a special kind of ineptitude to achieve such a feat.",
                "Take note, adventurers! [NEMESIS] was so horrendously bad that even [BYSTANDER] couldn't bear another moment in their company. It's a clear indication of the chaos and confusion they bring to any group.",
                "Witness the fallout, my friends! [NEMESIS] single-handedly drove [BYSTANDER] away with their bewildering gameplay. It seems their antics were too much to bear.",
                "Oh, the irony! [NEMESIS] was such a nightmare that even [BYSTANDER] chose to abandon ship. It seems their capacity for tolerating incompetence has reached its limit.",
                "Behold, the consequences of [NEMESIS]'s actions! [BYSTANDER] has chosen to flee, seeking refuge from the chaos and misery inflicted by [NEMESIS]'s gameplay. A wise decision indeed.",
                "The verdict is in, my friends! [NEMESIS] was so incredibly terrible that even [BYSTANDER] couldn't stand to be associated with them any longer. Their departure is a clear statement of [NEMESIS]'s inadequacy.",
                "Newsflash, adventurers! [NEMESIS] has achieved a new milestone in ineptitude. [BYSTANDER] has wisely decided to part ways, escaping the clutches of [NEMESIS]'s mind-numbing gameplay.",
                "Rumors abound, my comrades! [NEMESIS] has been so abominable that even [BYSTANDER] couldn't withstand their presence. The tales of their incompetence have spread far and wide.",
                "Well, look who couldn't handle [NEMESIS]'s gameplay! [BYSTANDER] just couldn't take it anymore and decided to bail. Can't say I blame them.",
                "Did you see that? [BYSTANDER] actually left the group because of [NEMESIS]. I guess they had enough of the chaos and frustration. Can't say I blame them for making a wise choice.",
                "It's official, [BYSTANDER] has left the group. Seems they had better things to do than suffer through [NEMESIS]'s incompetence. Can't say I blame them for seeking greener pastures.",
                "Well, well, well, [BYSTANDER] has left us. It's no surprise, really, considering [NEMESIS]'s performance. Who wants to stick around for that level of disappointment?",
                "Guess who couldn't handle [NEMESIS]'s gameplay? [BYSTANDER]. They must have reached their breaking point. I can't say I blame them for jumping ship.",
                "Looks like [BYSTANDER] had enough of [NEMESIS]'s antics. Can't say I blame them for deciding to part ways. No need to subject themselves to that level of frustration.",
                "Well, it seems [BYSTANDER] has seen the light and decided to leave. Smart move on their part, considering [NEMESIS]'s inability to contribute effectively. Who needs dead weight, right?",
                "Say goodbye to [BYSTANDER]! They've had their fill of [NEMESIS]'s gameplay and chose to walk away. Can't say I blame them for wanting a better group dynamic.",
                "Looks like [BYSTANDER] has had enough of [NEMESIS]'s poor performance. Can't really blame them for seeking a group where they can actually make progress.",
                "Well, [BYSTANDER] has made their exit. Can't say I blame them for leaving the sinking ship that is [NEMESIS]. It's a smart move for their own sanity.",
                "Did you see that? [BYSTANDER] left the group, probably tired of carrying [NEMESIS]'s dead weight. Can't say I blame them for wanting to be part of a competent team.",
                "Farewell, [BYSTANDER]! They've decided to move on and leave [NEMESIS] behind. Smart choice, if you ask me. Who wants to waste their time with incompetence?",
                "Well, well, well, [BYSTANDER] has chosen to depart from our group. Can't really blame them after witnessing [NEMESIS]'s lackluster performance. It's a shame to see them go, but it's for the best.",
                "It appears [BYSTANDER] couldn't bear [NEMESIS]'s gameplay any longer. Who can blame them? It's frustrating to be held back by someone who has no clue what they're doing.",
                "Adios, [BYSTANDER]! They've decided to seek better adventures elsewhere, far away from [NEMESIS]'s disastrous gameplay. Can't say I blame them for wanting to avoid the frustration.",
                "Well, well, well, [BYSTANDER] has thrown in the towel. Can't say I blame them after witnessing [NEMESIS]'s performance. It's hard to stick around when you're constantly facepalming.",
                "Goodbye, [BYSTANDER]! They've had enough of [NEMESIS]'s incompetence and opted for a group where they can actually make progress. Can't say I blame them for wanting to succeed.",
            }
        }
    },
    ["CHALLENGE"] = {
        ["START"] = {
            ["NA"] = {
                "Well, here we go, venturing into the depths of a mythic+ dungeon. Let's hope [NEMESIS] doesn't become the dead weight that sinks us all.",
                "Ah, the excitement of embarking on a challenging adventure. Just one question lingers in my mind: Can [NEMESIS] keep up with the rest of us?",
                "I'm cautiously optimistic about this mythic+ run. As long as [NEMESIS] doesn't drag us down with their incompetence, we might have a chance.",
                "Ladies and gentlemen, brace yourselves for the mythic+ journey ahead. Let's hope [NEMESIS] doesn't turn it into a comedy of errors.",
                "We stand at the threshold of a challenging dungeon. Will [NEMESIS] rise to the occasion or crumble under the pressure? Only time will tell.",
                "The adventure begins, and with it, the question of whether [NEMESIS] will be an asset or a liability. Time to find out, I suppose.",
                "In this mythic+ expedition, we face not only the dungeon's perils but also the uncertainty of [NEMESIS]'s abilities. May fortune favor us all.",
                "As we delve into the mythic+ depths, the success of our group rests on the shoulders of each member. Let's hope [NEMESIS] doesn't weigh us down too much.",
                "Hold onto your hats, folks, for we embark on a treacherous mythic+ adventure. Pray that [NEMESIS] doesn't become our Achilles' heel.",
                "The mythic+ challenge awaits, and with it, the mystery of [NEMESIS]'s competence. Will they rise to the occasion or become a liability?",
                "Here we go, into the crucible of mythic+ greatness. Let's hope [NEMESIS] doesn't become the weak link that shatters our dreams of success.",
                "As the mythic+ gates open, the question on everyone's mind is: Can [NEMESIS] keep up with the pace? The answer is yet to be revealed.",
                "We embark on a daring mythic+ escapade, with [NEMESIS] in tow. Will they be an asset to our group or a constant source of frustration?",
                "Prepare yourselves, brave adventurers, for the mythic+ challenge that lies ahead. Let's hope [NEMESIS] doesn't become our undoing.",
                "As we step into the realm of mythic+, uncertainty hangs in the air. Will [NEMESIS] rise above their shortcomings or succumb to them?",
                "The stage is set for a thrilling mythic+ adventure, with [NEMESIS] as our wildcard. Will they surprise us with their skills or disappoint us with their incompetence?",
                "Alright, folks, we're about to kick off this mythic+ run. Just a heads up, we've got [NEMESIS] in the group, so keep your expectations in check.",
                "Before we dive into this mythic+ madness, I want to prepare you all. We've got [NEMESIS] with us, so let's hope they can pull their weight.",
                "Listen up, team. We're starting a mythic+ dungeon, but I have some concerns. [NEMESIS] is joining us, and I hope they won't be dead weight.",
                "Attention, everyone. We're entering a challenging mythic+ dungeon, and I want to be honest. [NEMESIS] is part of the group, so let's hope for the best.",
                "Okay, team, buckle up for this mythic+ adventure. Just a friendly reminder that [NEMESIS] is with us, so be prepared for some shaky moments.",
                "Alright, folks, time to tackle this mythic+ dungeon head-on. I'll be frank: [NEMESIS] is joining us, so let's cross our fingers and hope for the best.",
                "Team, we're about to start this mythic+ run, but I want to level with you. We've got [NEMESIS] in our midst, so keep your expectations realistic.",
                "Listen, everyone. We're entering a mythic+ dungeon, and we've got [NEMESIS] in our group. I won't sugarcoat it—this might be a bumpy ride.",
                "Alright, team, let's get ready for this mythic+ challenge. Just a heads up, we've got [NEMESIS] in the mix, so keep an eye out for any struggles.",
                "Okay, folks, we're diving into this mythic+ dungeon, but I won't sugarcoat it. [NEMESIS] is part of our group, so let's hope they step up their game.",
                "Attention, everyone. We're starting a mythic+ run, and we've got [NEMESIS] on board. Let's hope they surprise us with their skills and not disappoint.",
                "Team, it's go time for this mythic+ expedition. I won't beat around the bush—[NEMESIS] is with us, so let's hope they can rise to the challenge.",
                "Alright, adventurers, get ready for this mythic+ endeavor. But here's the deal—[NEMESIS] is joining us, so be prepared for some bumps along the way.",
                "Listen up, team. We're entering a tough mythic+ dungeon, and we have [NEMESIS] in the group. Stay focused and be ready to support them if needed.",
                "Okay, team, let's tackle this mythic+ dungeon head-on. Just a word of caution—[NEMESIS] is joining us, so be prepared for some rough patches.",
                "Attention, everyone. We're embarking on a mythic+ challenge, and we'll be doing it with [NEMESIS]. Let's hope they can step up their game and surprise us.",
            },
        },
        ["FAIL"] = {
            ["NA"] = {
                "Well, well, well, look at that. We didn't complete the mythic+ dungeon in time, thanks to [NEMESIS]'s stellar performance.",
                "What a surprise! We fell short on the timer because [NEMESIS] couldn't keep up with the rest of us. Who could have seen that coming?",
                "It's no wonder we failed to beat the timer with [NEMESIS] in the group. Their incompetence held us back every step of the way.",
                "Another mythic+ run that ended in disappointment, all thanks to [NEMESIS]'s inability to pull their weight. I hope they're proud of themselves.",
                "Well, it looks like my concerns about [NEMESIS] were justified. Their poor gameplay just cost us completing the dungeon in time.",
                "And once again, [NEMESIS] manages to snatch defeat from the jaws of victory. Thanks for ensuring our failure, buddy.",
                "Oh, look, [NEMESIS] strikes again with their fantastic display of incompetence. It's like they have a talent for ruining our chances of success.",
                "I have to hand it to [NEMESIS], they really know how to bring down a team's morale. We didn't make it in time, all thanks to their lackluster performance.",
                "Well, what do you know? [NEMESIS] single-handedly managed to ensure our failure in this mythic+ dungeon. Bravo, truly impressive.",
                "I hate to say 'I told you so,' but [NEMESIS] really did prove to be the weak link that held us back from completing the dungeon in time.",
                "It's frustrating how one person's incompetence can drag down an entire group. Thanks for being that person, [NEMESIS].",
                "And the award for the biggest hindrance goes to none other than [NEMESIS]. Congratulations on derailing our mythic+ success.",
                "You know what's worse than failing a mythic+ run? Failing it because of [NEMESIS]'s inability to play their class properly.",
                "Well, that was a colossal waste of time. Thanks, [NEMESIS], for ensuring that our efforts went down the drain with your terrible performance.",
                "In the end, [NEMESIS]'s incompetence prevailed, and we fell short on the timer. I hope they realize the impact they had on our failure.",
                "And so, our dreams of completing the dungeon in time were shattered, all because of [NEMESIS]'s inability to contribute effectively. Thanks for nothing.",
                "Well, well, well, look who managed to mess up again. [NEMESIS], you really have a knack for failure, don't you?",
                "It's quite impressive, [NEMESIS]. Not everyone can consistently underperform like you do. Kudos on your dedication to mediocrity.",
                "I have to hand it to [NEMESIS]. They've perfected the art of disappointment. It's like their primary goal is to let us all down.",
                "I've seen better gameplay from a blindfolded gnome. Step up your game, [NEMESIS], or step out of the group.",
                "Oh, look, it's the master of failure, [NEMESIS]. Are you intentionally trying to make us all question your abilities?",
                "At this point, I'm convinced that [NEMESIS]'s incompetence is contagious. It's like a disease spreading through the group.",
                "Is there a 'Most Disappointing Player' award? Because [NEMESIS] would be a strong contender for that title.",
                "Oh, [NEMESIS], you really know how to make an impact—by consistently making terrible decisions and dragging us all down.",
                "I've seen novice adventurers with more skill than [NEMESIS]. Maybe they should consider finding a new hobby.",
                "It's remarkable, really. [NEMESIS] manages to amaze us all with their ability to consistently perform below expectations.",
                "You know what's great about having [NEMESIS] in the group? It sets the bar so low that the rest of us feel like heroes.",
                "The only consistency in [NEMESIS]'s gameplay is their inability to do anything right. Keep up the good work, I guess?",
                "You'd think [NEMESIS] would improve over time, but nope. They keep finding creative ways to disappoint us all.",
                "I'm beginning to suspect that [NEMESIS] has a secret agenda—to see how much frustration they can generate within the group.",
                "I have a theory, [NEMESIS]. You must be on a mission to break records in the 'Most Incompetent Player' category. You're doing great so far.",
                "It's fascinating, really. [NEMESIS] manages to consistently choose the worst possible option in any given situation. Bravo!",
            },
        },
        ["SUCCESS"] = {
            ["NA"] = {
                "Against all odds, we beat the timer with [NEMESIS] in tow. May the RNG Gods reward us with the best loot for carrying them!",
                "Incredible job, team! We finished in time despite [NEMESIS]'s incompetence. May the RNG Gods bless us with the loot we deserve!",
                "We defied expectations and triumphed over [NEMESIS]'s ineptitude. May the RNG Gods shower the group with epic loot for carrying them!",
                "We made it within the timer, even with [NEMESIS] dragging us down. Let's celebrate and hope the RNG Gods grant us the finest loot as a reward!",
                "Surprise! We exceeded all expectations with [NEMESIS] on board. May the RNG Gods smile upon us and bless us with the loot we deserve.",
                "Despite [NEMESIS], we emerged victorious within the timer. Let's revel in our success and pray that the RNG Gods reward us with epic loot!",
                "Impressive! We beat the timer despite [NEMESIS]'s best efforts. Let's celebrate and hope the RNG Gods grant us incredible loot!",
                "We proved that even with [NEMESIS] in the group, we're unstoppable. May the RNG Gods favor us and bless us with the best loot as a reward!",
                "Hats off! We completed in time, triumphing over [NEMESIS]'s attempts to hinder us. May the RNG Gods smile upon us and grant us legendary loot!",
                "We conquered the challenge with [NEMESIS] in tow. Let's revel in our success and hope the RNG Gods bless us with the best loot!",
                "Triumph! We surpassed expectations with [NEMESIS] on board. May the RNG Gods favor us and grant us epic loot for our accomplishment!",
                "Against all odds, we emerged victorious with [NEMESIS]. May the RNG Gods shower the group with top-tier loot for carrying them!",
                "We beat the timer despite [NEMESIS]'s best attempts. Let's celebrate our success and pray that the RNG Gods bless us with well-deserved loot!",
                "Incredible! We conquered with [NEMESIS] in tow. Let's rejoice and hope the RNG Gods grant us the finest loot to commemorate our victory!",
                "We made it within the timer, defying [NEMESIS]'s incompetence. Let's celebrate our triumph and pray that the RNG Gods bless us with legendary loot as our reward!",
                "Surpassing all expectations, we triumphed with [NEMESIS]. May the RNG Gods smile upon us and shower the group with epic loot for carrying them!",
                "Well, well, well, look at us! We completed the mythic+ in time, despite [NEMESIS] being dead weight. Let's pray to the RNG Gods for the most glorious loot!",
                "Against all odds, we triumphed over [NEMESIS]'s incompetence and finished within the timer. May the RNG Gods reward us generously for carrying them!",
                "Incredible job, everyone! Despite [NEMESIS]'s best efforts to hinder us, we conquered the mythic+ in time. Now, let's hope the RNG Gods bless us with legendary loot!",
                "We defied the odds and completed the mythic+ in time, even with [NEMESIS] dragging us down. Let's send our prayers to the RNG Gods for the most magnificent loot!",
                "Surprise, surprise! We outperformed ourselves with [NEMESIS] on board. Let's keep our fingers crossed and hope the RNG Gods grant us epic loot as a reward!",
                "Despite [NEMESIS], we emerged victorious within the timer. Let's rejoice and beseech the RNG Gods for bountiful loot that matches our triumph!",
                "Impressive! We surpassed all expectations and beat the timer, despite [NEMESIS]'s best attempts to hinder us. May the RNG Gods favor us with incredible loot!",
                "We proved that even with [NEMESIS] in the group, we're an unstoppable force. Let's celebrate our success and pray to the RNG Gods for the best loot possible!",
                "Hats off to the group! We completed the mythic+ in time, triumphing over [NEMESIS]'s attempts to hold us back. Let's offer our prayers to the RNG Gods for legendary loot!",
                "We conquered the challenge with [NEMESIS] in tow. Let's rejoice in our victory and implore the RNG Gods to bless us with the most extraordinary loot!",
                "Triumph! We surpassed expectations with [NEMESIS] on board. Let's give thanks to the RNG Gods and hope they grant us epic loot as a token of our accomplishment!",
                "Against all odds, we emerged victorious with [NEMESIS] by our side. Let's bask in our glory and pray to the RNG Gods for a shower of top-tier loot!",
                "We beat the timer despite [NEMESIS]'s best attempts. Let's revel in our success and send our wishes to the RNG Gods for well-deserved loot!",
                "Incredible! We conquered the challenge with [NEMESIS] in tow. May the RNG Gods smile upon us and bless us with the finest loot as a tribute to our victory!",
                "We made it within the timer, defying [NEMESIS]'s incompetence. Let's celebrate our triumph and beseech the RNG Gods for legendary loot to mark our accomplishment!",
                "Surpassing all expectations, we triumphed with [NEMESIS] in the group. Let's offer our prayers to the RNG Gods for top-tier loot, as they witnessed our victory over adversity!",
            },
        }
    }
}

core.ai.praises = {
    ["BOSS"] = {
        ["FAIL"] = {
            ["NA"] = {
                "Oops, failed again! [BYSTANDER] deserves a medal for enduring my bumbling attempts against [BOSSNAME]. We'll get 'em next time!",
                "Well, here I go failing in style once more. Hats off to [NEMESIS] for their extraordinary patience. Together, we'll conquer [BOSSNAME]!",
                "Another day, another epic fail courtesy of yours truly. Massive shoutout to [BYSTANDER] for carrying me through the fight against [BOSSNAME]!",
                "I must be the world's greatest expert in failing. But hey, thanks to [NEMESIS], we'll turn this defeat into a legendary comeback against [BOSSNAME]!",
                "Well, I've done it again: transformed victory into glorious defeat. Props to [BYSTANDER] for their unwavering support. Onward to redemption against [BOSSNAME]!",
                "Oops, did someone order a masterclass in epic failure? Huge thanks to [NEMESIS] for sticking by me through the struggle against [BOSSNAME]!",
                "Defeat has never looked so... well, defeat-y! Kudos to [BYSTANDER] for their dedication. We'll dust ourselves off and emerge victorious against [BOSSNAME]!",
                "Well, it's official: I've become a pro at disappointing everyone. But fear not, thanks to [NEMESIS], failure only makes the eventual victory sweeter!",
                "Failed spectacularly once more! Major props to [BYSTANDER] for enduring my calamitous performance against [BOSSNAME]. We'll bounce back stronger!",
                "Guess who just added another failure to their highlight reel? That's right, me! Shoutout to [NEMESIS] for their incredible support. Onward to triumph over [BOSSNAME]!",
                "Failure? Yep, that's my specialty! Thanks to [BYSTANDER], we'll turn this mishap into a stepping stone towards conquering [BOSSNAME]!",
                "Well, I've taken the concept of failure to new heights. Thanks to [NEMESIS] for their unwavering belief in my potential. Together, we'll overcome [BOSSNAME]!",
                "Failed to impress once more! Cheers to [BYSTANDER] for their patience and unwavering dedication. Onward to a glorious victory against [BOSSNAME]!",
                "Oops, did I accidentally stumble into defeat again? Kudos to [NEMESIS] for their outstanding performance. We'll come back stronger and triumph over [BOSSNAME]!",
                "Yet another glorious display of my epic failure! Hats off to [BYSTANDER] for their support and perseverance. Together, we'll conquer [BOSSNAME]!",
                "Well, I've successfully mastered the art of disappointment. Thanks to [NEMESIS], failure is just a temporary setback on our path to victory against [BOSSNAME]!",
                "Failed to meet expectations once again! Huge shoutout to [BYSTANDER] for their heroic efforts. We'll regroup and crush [BOSSNAME] in the next attempt!",
                "Oh look, it's me failing spectacularly! A special mention to [NEMESIS] for their unwavering faith. We'll turn this defeat into a triumphant victory against [BOSSNAME]!",
                "Failed to deliver yet again! A big round of applause for [BYSTANDER] for carrying me through the battle against [BOSSNAME]. Next time, we'll nail it!",
                "Well, I've officially reached the pinnacle of failure. But thanks to [NEMESIS], we'll rise from the ashes and conquer [BOSSNAME] with unparalleled glory!",
                "Failed miserably once more! Huge thanks to [BYSTANDER] for their remarkable patience and support. Together, we'll emerge victorious against [BOSSNAME]!",
                "Another day, another failure! Kudos to [NEMESIS] for their unwavering belief in my potential. We'll learn from this and triumph over [BOSSNAME]!",
                "Oops, there goes my streak of failure! Thanks to [BYSTANDER] for their incredible resilience. We'll regroup and triumph over [BOSSNAME] in no time!",
                "Failed to impress yet again! Shoutout to [NEMESIS] for their unwavering support and belief. Together, we'll overcome [BOSSNAME] and celebrate in style!",
                "Well, it's official: I'm the epitome of failure. But thanks to [BYSTANDER], every setback is just an opportunity for an epic comeback against [BOSSNAME]!",
                "Another failure to add to my illustrious collection! A huge round of applause for [NEMESIS] for their exceptional support. We'll conquer [BOSSNAME] soon!",
                "Failed to meet the mark once again! Hats off to [BYSTANDER] for carrying me through the encounter with [BOSSNAME]. Together, we'll achieve greatness!",
                "Oops, I did it again! Thanks to [NEMESIS], failure is just a stepping stone on our journey towards conquering [BOSSNAME]!",
                "Failed in spectacular fashion! A special shoutout to [BYSTANDER] for their incredible dedication. We'll regroup and triumph over [BOSSNAME] in the next attempt!",
                "Well, I've certainly mastered the art of failing. But thanks to [NEMESIS], we'll turn this defeat into a tale of redemption against [BOSSNAME]!",
                "Failed to deliver once more! Big kudos to [BYSTANDER] for their unwavering support and patience. Together, we'll overcome [BOSSNAME] and taste victory!",
                "Oops, another failure to add to my list! Thanks to [NEMESIS], every defeat is just a prelude to our ultimate triumph over [BOSSNAME]!",
                "Failed spectacularly, as expected! A round of applause for [BYSTANDER] for their extraordinary efforts. We'll regroup and conquer [BOSSNAME] in style!",
                "Well, I've done it again: snatched defeat from the jaws of victory. Thanks to [NEMESIS], we'll bounce back and make [BOSSNAME] regret ever crossing our path!",
                "Failed to rise to the occasion, as always! Massive thanks to [BYSTANDER] for their incredible patience. Together, we'll achieve the impossible against [BOSSNAME]!"
            }
        },
        ["DEATH"] = {
            ["SELF"] = {
                "Oops, I guess I tripped and fell right into the boss's clutches. Good luck, everyone!",
                "Well, it seems the boss wanted to give me a personal welcome. I'll just take a short break here.",
                "Oh dear, it appears I underestimated the boss's love for targeting me. Someone carry on the fight without me!",
                "Note to self: don't try to become best friends with the boss. They tend to have a crush on me.",
                "I always knew my dance moves were too mesmerizing for the boss to handle. I'll be back after this short intermission.",
                "You know what they say, 'dying is just a part of my grand strategy.' Keep up the good fight, everyone!",
                "Who needs an extra challenge? I'll just take a quick nap on the boss's behalf. Carry on, brave souls!",
                "I seem to have taken a detour to the boss's realm of doom. Don't worry, I'll be back to join the battle soon... probably.",
                "Fear not, my demise is just a clever distraction to keep the boss on their toes. Keep fighting, heroes!",
                "Looks like the boss has a special affinity for me. I'll be back in the game as soon as I stop enjoying this cozy floor.",
                "I'm just providing some comic relief to the boss's otherwise serious performance. Carry on, fearless warriors!",
                "Who needs a healer when you have me, the expert at discovering creative ways to meet the floor? Keep the boss busy for me!",
                "Ah, another dramatic exit by yours truly. Take this opportunity to showcase your amazing skills, my fellow adventurers!",
                "Don't worry, I'm just giving the boss a false sense of triumph. I'll be back to steal the spotlight soon enough!",
                "I must admit, getting up close and personal with the boss wasn't part of my plan. Carry on, valiant comrades!",
                "I've always wanted to test the limits of the boss's attacks. Now that I have, you all can carry the torch of victory!",
                "Well, that was a spectacular demonstration of my unique combat technique. Keep up the good work, everyone!",
                "In my quest for the most extravagant battle exit, I may have gone a bit too far. Carry on, brave warriors!",
                "I've decided to take a moment to appreciate the boss's formidable power up close. Don't worry, I'll catch up!",
                "The boss clearly wanted to challenge my incredible resilience. Now it's your turn to show them what you've got!",
                "A temporary setback on my path to greatness. Keep fighting, my heroic allies!",
                "Oops, I seemed to have misplaced my invincibility cloak. Carry on, fearless warriors!",
                "Just when I thought the boss couldn't resist my charms any longer, they decided to pay me a visit. Keep up the good fight!",
                "I'll just take a quick detour to the boss's realm of mayhem. You all handle the heroics for now!",
                "In a plot twist, the boss and I decided to exchange roles momentarily. Carry on, valiant champions!",
                "I may have underestimated the boss's enthusiasm to meet me face-to-face. Keep fighting, my resilient companions!",
                "They say every great hero needs a dramatic fall. I'm just adding a touch of flair to our epic battle. Keep going!",
                "Well, I always wanted to be the center of attention. Enjoy the spotlight, my brave comrades!",
                "Looks like the boss really wanted a closer look at my exceptional dodging skills. Carry on, heroes!",
                "I've graciously given the boss a moment to celebrate my presence. Now it's your chance to shine!",
                "A temporary setback is just a part of my grand strategy to test your mettle, my valiant allies. Onward to victory!",
                "I'm just taking a brief intermission in the boss's domain. Carry on without me, champions of glory!"
            },
            ["NEMESIS"] = {
                "[NEMESIS] has fallen! Panic mode activated! We'll avenge them and show [BOSSNAME] who's boss!",
                "Oh no! [NEMESIS] has been taken down by [BOSSNAME]'s might! We must rally and fight even harder!",
                "The mighty [NEMESIS] has met their match! Fear not, we'll channel their heroic spirit to defeat [BOSSNAME]!",
                "Alas, [NEMESIS] has succumbed to [BOSSNAME]'s wrath! But we'll rise from the ashes and claim victory in their honor!",
                "In a shocking twist, [NEMESIS] has been vanquished! Now it's our turn to face [BOSSNAME] with unwavering resolve!",
                "No! [NEMESIS] couldn't evade [BOSSNAME]'s deadly strike! We'll honor their memory by toppling the boss!",
                "The legendary [NEMESIS] has fallen! Let their sacrifice fuel our determination to conquer [BOSSNAME]!",
                "Even [BOSSNAME]'s power couldn't withstand the might of [NEMESIS]! We'll avenge their valiant effort!",
                "Brace yourselves! [NEMESIS] has been defeated by [BOSSNAME], but their legacy lives on within us!",
                "Oh dear, [NEMESIS] couldn't outrun [BOSSNAME]'s onslaught! But we won't falter—we'll seize victory in their honor!",
                "The formidable [NEMESIS] has met their match! Let's pay tribute to their valiant effort by emerging victorious!",
                "Witnessing [NEMESIS]'s defeat reminds us that even the strongest can fall. But together, we'll conquer [BOSSNAME]!",
                "No one expected [BOSSNAME] to claim victory over [NEMESIS], but we'll show them what true resilience means!",
                "[NEMESIS]'s fateful encounter with [BOSSNAME] serves as a rallying cry! Let's turn the tides and emerge triumphant!",
                "Oh, [NEMESIS], you're too captivating for [BOSSNAME] to resist! We'll carry your spirit and conquer the boss in style!",
                "Hats off to [NEMESIS] for their impressive dance with [BOSSNAME]! We'll honor their performance with a resounding victory!",
                "Even the mightiest warriors like [NEMESIS] can't escape [BOSSNAME]'s clutches. But we'll make their sacrifice count!",
                "The grand saga of [NEMESIS] and [BOSSNAME] continues! We'll ensure their story ends in our triumph!",
                "[NEMESIS]'s unfortunate meeting with [BOSSNAME] won't deter us! We'll forge ahead, guided by their indomitable spirit!",
                "Despite [NEMESIS]'s best efforts, [BOSSNAME] proved to be their kryptonite. But we'll be their superpowered comeback!",
                "Oh no, [NEMESIS]! You fell victim to [BOSSNAME]'s wrath, but we'll rise together and bring them down!",
                "Hold your heads high! [NEMESIS] valiantly challenged [BOSSNAME], paving the way for our eventual victory!",
                "The loss of [NEMESIS] stings, but it fuels our determination to overcome [BOSSNAME]'s relentless assault!",
                "Salute to [NEMESIS] for their daring encounter with [BOSSNAME]! We'll use their sacrifice as our ultimate catalyst!",
                "In a shocking twist, [NEMESIS] has been defeated! But we'll pick up the mantle and claim triumph over [BOSSNAME]!",
                "Unfortunate turn of events! [BOSSNAME] shattered [NEMESIS]'s defenses. We'll retaliate with renewed vigor!",
                "Kudos to [NEMESIS] for showcasing their resilience against [BOSSNAME]! We'll take up the mantle and prevail!",
                "Even [BOSSNAME] couldn't resist the allure of [NEMESIS]'s valor! We'll ensure their efforts were not in vain!",
                "Woe betide [NEMESIS]! [BOSSNAME] has bested them, but we'll emerge victorious and carry their legacy forward!",
                "We'll turn [NEMESIS]'s defeat into a triumphant tale! With their spirit as our guide, we'll conquer [BOSSNAME]!",
                "Though [NEMESIS] has fallen, their impact on this battle is immeasurable! We'll rise and finish what they started!",
                "Stand firm, for [NEMESIS] has paved the way for our victory against [BOSSNAME]! Their memory fuels our resolve!"
            },
            ["BYSTANDER"] = {
                "Oh no! [BYSTANDER] has been defeated by [BOSSNAME]'s relentless assault! We must prevail in their honor!",
                "[BYSTANDER] has succumbed to [BOSSNAME]'s might! Let's rally together and turn the tide of this battle!",
                "In a tragic turn of events, [BYSTANDER] has fallen victim to [BOSSNAME]'s power! We'll avenge them with unwavering determination!",
                "Alas, [BYSTANDER] couldn't withstand [BOSSNAME]'s onslaught! But fear not, their spirit will guide us to victory!",
                "[BYSTANDER]'s valiant efforts weren't enough to overcome [BOSSNAME]'s wrath! But we'll carry their torch and emerge triumphant!",
                "No! [BYSTANDER] has met their match against [BOSSNAME]'s formidable might! We'll honor their bravery and claim victory!",
                "The indomitable [BYSTANDER] has been defeated by [BOSSNAME]'s power! But we'll rise together and turn the tides of this battle!",
                "Oh, [BYSTANDER], you've left us too soon! But your memory will inspire us to overcome [BOSSNAME] and emerge victorious!",
                "Hold the line! [BYSTANDER] fought valiantly against [BOSSNAME] but fell. Let's honor their sacrifice with a resounding triumph!",
                "Despite [BYSTANDER]'s best efforts, they couldn't withstand [BOSSNAME]'s onslaught. But we'll avenge them with unwavering determination!",
                "Raise your weapons! [BYSTANDER] may have fallen, but we'll channel their courage and turn this battle in our favor!",
                "Oh no, [BOSSNAME] claimed [BYSTANDER]'s life! But we'll fight on, fueled by their heroic sacrifice!",
                "In the face of [BOSSNAME]'s relentless assault, [BYSTANDER] succumbed. But we'll rise together and triumph in their memory!",
                "Even the most valiant efforts of [BYSTANDER] couldn't withstand the wrath of [BOSSNAME]. But we'll avenge them and claim victory!",
                "Woe befalls us! [BYSTANDER] fought bravely but met their end at the hands of [BOSSNAME]. Let's turn the tide and prevail!",
                "Though [BYSTANDER] has fallen, their bravery will forever be etched in our hearts. Together, we'll conquer [BOSSNAME]!",
                "The loss of [BYSTANDER] leaves a void, but their spirit will guide us to victory against [BOSSNAME]!",
                "Salute to [BYSTANDER] for their courageous stand against [BOSSNAME]! We'll carry their memory as we overcome this challenge!",
                "In a twist of fate, [BYSTANDER] has been taken down by [BOSSNAME]. But we'll rise from this setback and claim triumph!",
                "Stand tall! Though [BYSTANDER] fell, their legacy will inspire us to vanquish [BOSSNAME] once and for all!",
                "Oh, [BYSTANDER], your valiant efforts against [BOSSNAME] shall not be forgotten! We'll carry your spirit to victory!",
                "With heavy hearts, we mourn the loss of [BYSTANDER]. But we'll honor their memory by defeating [BOSSNAME]!",
                "The might of [BOSSNAME] was too great for [BYSTANDER] to overcome. But together, we'll overcome this challenge in their name!",
                "Though [BYSTANDER] has fallen, their spirit lives on within us! We'll turn their sacrifice into our triumph!",
                "Fear not, for [BYSTANDER] will forever be remembered for their bravery against [BOSSNAME]. We'll carry their torch to victory!",
                "Raise your voices! [BYSTANDER] may have fallen, but their impact on this battle will not be in vain! We'll conquer [BOSSNAME]!",
                "Oh dear, [BYSTANDER]! Their bravery couldn't withstand [BOSSNAME]'s onslaught. But we'll avenge them and emerge victorious!"
              },
        },
        ["START"] = {
            ["NA"] = {
                "Boss fight time! Brace yourselves for my clumsy attempts, knowing [NEMESIS] will cover for my glorious mishaps!",
                "Here we go! Pray that I don't accidentally pull aggro, while [BYSTANDER] saves the day with their heroic skills!",
                "Boss incoming! Get ready for my questionable decisions, offset by [NEMESIS]'s miraculous cover-ups!",
                "Hold on tight! I'll try not to embarrass myself too much, knowing [BYSTANDER] is there to compensate for my blunders!",
                "Boss encounter activated! Witness my missteps, followed by [NEMESIS]'s awe-inspiring skills to keep us on track!",
                "It's showtime! Expect the unexpected from me, while [BYSTANDER] shows off their greatness to offset my antics!",
                "Ready or not, here we go! Hoping for miracles from [NEMESIS] to compensate for my blunders, while [BYSTANDER] works their magic!",
                "Boss fight starting! Prepare for my accidental heroics, balanced by [NEMESIS]'s true heroism to save the day!",
                "Let the boss dance begin! Watch me stumble, knowing [BYSTANDER] will waltz with grace to compensate for my missteps!",
                "Boss encounter initiated! Brace for my mishaps, followed by [NEMESIS]'s extraordinary rescue missions to keep us afloat!",
                "Hold your breath! I'll try not to be a liability, while [BYSTANDER] carries the team on their capable shoulders!",
                "Boss fight commencing! Expect my special brand of chaos, offset by [NEMESIS]'s greatness to keep us in line!",
                "Here we go! Prepare for my questionable tactics, knowing [BYSTANDER] will step up and show us the way to victory!",
                "Get ready for the boss showdown! I'll be the comic relief, while [NEMESIS] carries the weight and ensures our success!",
                "Time to face the boss! Pray that I don't accidentally press all the wrong buttons, while [BYSTANDER] works their magic to guide us to victory!",
                "Boss battle engaged! Prepare for my amusing blunders, followed by [NEMESIS]'s unmatched skill to compensate for my antics!",
                "Hold onto your hats! I'll try not to get us all killed, while [BYSTANDER] carries us to victory with their extraordinary prowess!",
                "Boss encounter initiated! Expect me to be the entertainment, while [NEMESIS] becomes the true hero, compensating for my glorious blunders!",
                "Let's tackle this boss together! I'll provide the laughs, while [BYSTANDER] brings their exceptional skills to ensure our victory!",
                "Boss fight starting! Brace for my clumsy maneuvers, knowing [NEMESIS] will step up with their incredible saves to keep us on track!",
                "Ready for the boss challenge? I'll bring the chaos, while [BYSTANDER] brings the glory and ensures our triumphant success!",
                "Boss battle time! I'll do my best not to be a liability, while [NEMESIS] shines and compensates for my glorious blunders!",
                "Prepare for the boss rumble! Witness my comedic brilliance, knowing [BYSTANDER] will be there to carry us to victory in the face of my glorious mishaps!",
                "Hold onto your sanity! I'll do my best to contribute, while [NEMESIS] carries the weight of our success on their capable shoulders!",
                "Boss encounter activated! Get ready for my epic fails, offset by [BYSTANDER]'s extraordinary triumphs that will lead us to victory!",
                "Time to face the boss! Expect my amusing blunders, redeemed by [NEMESIS]'s unwavering heroism to ensure our glorious triumph!",
                "Boss fight incoming! Brace for my questionable decision-making, followed by [BYSTANDER]'s extraordinary saves that will keep us on the path to victory!",
                "Get your game faces on! I'll provide the amusement, while [NEMESIS] delivers the excellence that will ensure our triumphant success!",
                "Ready for the boss challenge? Watch me stumble and fumble, knowing that [BYSTANDER] will be there to compensate for my hilarious missteps!",
                "Boss fight commencing! Expect my glorious chaos, balanced by [NEMESIS]'s exceptional skill in saving the day and ensuring our victorious triumph!",
                "Here we go! Brace yourselves for my mishaps, knowing [BYSTANDER] will step up with their unparalleled prowess to compensate for my glorious blunders!",
                "Get ready for the boss encounter! Witness my hilarious blunders, followed by [NEMESIS]'s exceptional abilities to carry us to victory!",
                "Time to face the boss together! I'll bring the laughs and entertainment, while [BYSTANDER] showcases their phenomenal skills to ensure our success!",
            }
        },
        ["SUCCESS"] = {
            ["NA"] = {
                "Victory! Thanks to [NEMESIS] for carrying me through the battle against [BOSSNAME] and saving the day!",
                "We did it! Shoutout to [BYSTANDER] for their exceptional skills in compensating for my glorious incompetence against [BOSSNAME]!",
                "Triumph! [NEMESIS] deserves all the credit for covering my tracks and leading us to victory over [BOSSNAME]!",
                "Hooray! Huge thanks to [BYSTANDER] for their remarkable abilities that carried us through the fight with [BOSSNAME]!",
                "Success! [NEMESIS] showcased their unmatched prowess, compensating for my numerous blunders in the battle against [BOSSNAME]!",
                "We emerged victorious! Kudos to [BYSTANDER] for their extraordinary skills that triumphed over the challenges posed by [BOSSNAME]!",
                "Celebrations are in order! [NEMESIS] truly shone in the face of my glorious failures during the epic encounter with [BOSSNAME]!",
                "We conquered [BOSSNAME]! Gratitude to [BYSTANDER] for their exceptional talents that compensated for my numerous shortcomings!",
                "We achieved triumph! It's all thanks to [NEMESIS] who expertly compensated for my mishaps in the battle against [BOSSNAME]!",
                "Cheers to victory! Hats off to [BYSTANDER] for their outstanding skills that saved us from disaster in the clash with [BOSSNAME]!",
                "A glorious win! [NEMESIS] proved their mettle, stepping up to cover for my numerous blunders in the face of [BOSSNAME]!",
                "We emerged triumphant! Special shoutout to [BYSTANDER] for their incredible prowess in overcoming the challenges presented by [BOSSNAME]!",
                "Success is ours! [NEMESIS] deserves the utmost praise for their remarkable abilities that compensated for my blunders against [BOSSNAME]!",
                "Victory is sweet! Hats off to [BYSTANDER] for their extraordinary skills that carried us through the grueling encounter with [BOSSNAME]!",
                "Triumphant moments! [NEMESIS] was the true hero, compensating for my failures and leading us to victory against [BOSSNAME]!",
                "We emerged victorious! A massive thanks to [BYSTANDER] for their exceptional contributions that brought down [BOSSNAME]!",
                "Success tastes sweeter! [NEMESIS] displayed their incredible prowess, compensating for my shortcomings in the battle with [BOSSNAME]!",
                "Hooray for victory! [BYSTANDER] truly stood out, compensating for my numerous blunders in the face of [BOSSNAME]'s challenges!",
                "We emerged triumphant! Kudos to [NEMESIS] for their exceptional skills that compensated for my glorious failures against [BOSSNAME]!",
                "Celebrations are in order! [BYSTANDER] showcased their extraordinary talents, compensating for my mishaps during the epic clash with [BOSSNAME]!",
                "A glorious triumph! [NEMESIS] deserves all the praise for their remarkable abilities that led us to victory against [BOSSNAME]!",
                "We conquered [BOSSNAME]! Huge thanks to [BYSTANDER] for their outstanding skills that compensated for my shortcomings in the battle!",
                "Success is ours! [NEMESIS] showcased their unparalleled prowess, compensating for my failures and guiding us to victory over [BOSSNAME]!",
                "Cheers to victory! [BYSTANDER] proved their exceptional abilities, carrying us through the challenges posed by [BOSSNAME]!",
                "Triumph is ours! [NEMESIS] was the true hero, covering for my mistakes and leading us to victory against [BOSSNAME]!",
                "We emerged victorious! Special shoutout to [BYSTANDER] for their exceptional talents that contributed to our triumph over [BOSSNAME]!",
                "Success is sweet! [NEMESIS] displayed their unmatched skills, compensating for my shortcomings and ensuring victory against [BOSSNAME]!",
                "Victory is ours! [BYSTANDER] showcased their extraordinary abilities, picking up the slack and guiding us to triumph against [BOSSNAME]!",
                "Triumphant moments! [NEMESIS] stepped up, compensating for my mishaps and leading us to victory against [BOSSNAME]!",
                "We emerged victorious! Kudos to [BYSTANDER] for their exceptional skills that compensated for my glorious failures in the battle against [BOSSNAME]!",
                "Success tastes sweeter! [NEMESIS] proved their remarkable abilities, compensating for my shortcomings and guiding us to victory against [BOSSNAME]!",
                "Hooray for victory! [BYSTANDER] stood out with their exceptional talents, compensating for my numerous blunders in the face of [BOSSNAME]!",
                "We conquered [BOSSNAME]! Massive thanks to [NEMESIS] for their outstanding skills that compensated for my shortcomings and secured our triumph!",
                "Success is ours! [BYSTANDER] showcased their extraordinary abilities, carrying us through the challenges posed by [BOSSNAME] and leading us to victory!",
            }
        }
    },
    ["GROUP"] = {
        ["JOIN"] = {
            ["NEMESIS"] = {
                "Welcome, [NEMESIS], to our esteemed group! Your presence fills us with anticipation and excitement. Together, we shall conquer any challenge!",
                "A warm welcome to [NEMESIS], the epitome of skill and expertise! We're honored to have you join our group on this incredible journey.",
                "Hail, [NEMESIS], the legendary hero who graces us with their presence! Your arrival guarantees our success and inspires us to greatness.",
                "Gather 'round, adventurers, and witness the arrival of [NEMESIS]! We're privileged to embark on this journey with such a formidable ally.",
                "We extend a hearty welcome to [NEMESIS], the paragon of excellence! With your unparalleled abilities, our group is destined for greatness.",
                "Ah, [NEMESIS], the prodigious champion, has arrived! Your mastery of the game leaves us in awe, and we're thrilled to have you with us.",
                "Welcome, [NEMESIS], the embodiment of skill and prowess! Your inclusion fortifies our confidence and guarantees a triumphant adventure.",
                "A grand welcome to [NEMESIS], whose name echoes through the realms of gaming! We're honored to have you among us on this remarkable journey.",
                "Greetings, [NEMESIS], the unparalleled force of nature! Your arrival sets a new standard for our group, and we're elated to embark on this epic quest.",
                "Behold, [NEMESIS], the legend who walks among us! Your presence elevates our group to new heights, and we're privileged to have you as part of our fellowship.",
                "Welcome, [NEMESIS], the living embodiment of greatness! Your skills and experience bring an unmatched level of proficiency to our group.",
                "A resounding welcome to [NEMESIS], the maestro of the game! With your arrival, our group gains a master strategist and a beacon of inspiration.",
                "Hail, [NEMESIS], the virtuoso who graces our group with their presence! Your arrival ensures our success, and we eagerly anticipate the remarkable achievements.",
                "Welcome, [NEMESIS], the embodiment of gaming excellence! Your presence fills us with confidence and excitement, knowing that with you by our side, victory is within reach.",
                "Greetings, [NEMESIS], the conqueror of realms! We're honored to have you join our group, and we're certain that your unmatched skills will lead us to triumph.",
                "A warm welcome to [NEMESIS], the prodigious talent we've been privileged to have among us! With your exceptional abilities, our group is poised for success.",
                "Behold, [NEMESIS], the indomitable force that joins our group! Your arrival emboldens us and ensures that our path to victory is marked by skill and resilience.",
                "Welcome, [NEMESIS], the epitome of gaming prowess! Your reputation precedes you, and we're elated to have you as part of our group on this awe-inspiring adventure.",
                "A grand welcome to [NEMESIS], the guardian of greatness! Your inclusion in our group adds a new level of expertise and raises our chances of success.",
                "Greetings, [NEMESIS], the luminary of the game! Your arrival fills us with optimism and excitement for the remarkable adventures that await us.",
                "Behold, [NEMESIS], the paragon of skill! Your presence in our group elevates us to new heights and instills a sense of invincibility in our hearts.",
                "Welcome, [NEMESIS], the legend in our midst! Your reputation precedes you, and we're privileged to embark on this epic journey with you by our side.",
                "A warm welcome to [NEMESIS], the embodiment of excellence! Your inclusion in our group promises extraordinary achievements and unforgettable experiences.",
                "Hail, [NEMESIS], the master of mastery! Your arrival inspires us all to push our limits and sets the stage for incredible accomplishments.",
                "Welcome, [NEMESIS], the guardian of greatness! Your presence in our group assures us that we're on the path to triumph. Let's achieve greatness together!",
                "Greetings, [NEMESIS], the luminary of skill! Your inclusion in our group fills us with confidence and excitement. Let's conquer the challenges that lie ahead!",
            },
            ["SELF"] = {
                "Welcome, [NEMESIS]! Glad to have you in the group. Together, let's tackle challenges and achieve success!",
                "Great to see you, [NEMESIS]! With your skills and expertise, our group just got stronger. Let's make the most of our adventure!",
                "Hello, [NEMESIS]! It's awesome to have you with us. Let's work together and conquer any obstacles that come our way!",
                "Welcome aboard, [NEMESIS]! Your presence adds a new dimension to our group. Let's collaborate and make this adventure memorable!",
                "Hey, [NEMESIS]! Joining forces with you elevates our group's capabilities. Let's support each other and strive for greatness!",
                "Glad you're here, [NEMESIS]! With your experience, we're well-equipped for this journey. Let's accomplish our goals together!",
                "Welcome, [NEMESIS]! Your reputation precedes you, and we're thrilled to have you join us. Let's face challenges head-on and emerge victorious!",
                "Hello, [NEMESIS]! Your skills are highly regarded, and we're lucky to have you on our team. Let's collaborate and make this adventure a success!",
                "Great to have you, [NEMESIS]! Your expertise will be invaluable to our group. Let's support each other and achieve remarkable things!",
                "Welcome, [NEMESIS]! Your presence brings excitement to our group. Let's work together, learn from each other, and accomplish great feats!",
                "Hey, [NEMESIS]! We've heard great things about you, and we're delighted to have you join us. Let's unite our strengths and conquer challenges!",
                "Glad to see you, [NEMESIS]! Your skills and experience will greatly benefit our group. Let's collaborate and make this adventure a memorable one!",
                "Welcome aboard, [NEMESIS]! Your addition to the group is much appreciated. Let's support each other and strive for excellence!",
                "Hello, [NEMESIS]! We're thrilled to have you join us. Together, let's overcome any obstacles and achieve remarkable success!",
                "Great to have you with us, [NEMESIS]! Your expertise and abilities will be a valuable asset. Let's work together and make this journey remarkable!",
                "Welcome, [NEMESIS]! Your presence enhances our group. Let's combine our strengths and accomplish extraordinary things!",
                "Hello, [NEMESIS]! We've been looking forward to having you in our group. Let's collaborate and make this adventure an unforgettable experience!",
                "Glad you could join us, [NEMESIS]! With your skills, we're well-prepared for the challenges ahead. Let's support each other and succeed together!",
                "Welcome, [NEMESIS]! Your joining brings a new dynamic to our group. Let's leverage our collective strengths and accomplish great things!",
                "Hey, [NEMESIS]! We're excited to have you on board. Let's unite our efforts and make this adventure a resounding success!",
                "Glad to see you here, [NEMESIS]! Your expertise and abilities will be invaluable to our group. Let's work together and make this journey remarkable!",
            },
            ["BYSTANDER"] = {
                "Welcome, [BYSTANDER]! We're glad to have you join our group. Together, let's tackle challenges and achieve success!",
                "Great to see you, [BYSTANDER]! Your presence adds to the strength of our group. Let's collaborate and make the most of our adventure!",
                "Hello, [BYSTANDER]! It's awesome to have you with us. Let's work together and overcome any obstacles that come our way!",
                "Welcome aboard, [BYSTANDER]! Your joining brings a new perspective to our group. Let's collaborate and make this adventure memorable!",
                "Hey, [BYSTANDER]! We're thrilled to have you on our team. Let's support each other and strive for greatness!",
                "Glad you're here, [BYSTANDER]! Your presence enhances our group's dynamics. Let's work together and accomplish remarkable things!",
                "Welcome, [BYSTANDER]! Your unique skills and abilities are a valuable addition to our group. Let's collaborate and face challenges head-on!",
                "Hello, [BYSTANDER]! We're excited to have you join us. Let's combine our strengths and make this adventure a resounding success!",
                "Great to have you, [BYSTANDER]! Your expertise and experience will greatly benefit our group. Let's support each other and achieve remarkable things!",
                "Welcome, [BYSTANDER]! Your presence brings a fresh energy to our group. Let's unite our strengths and conquer challenges together!",
                "Hey, [BYSTANDER]! We're delighted to have you join our team. Let's work together, learn from each other, and accomplish great feats!",
                "Glad to see you, [BYSTANDER]! Your skills and abilities will greatly contribute to our group's success. Let's collaborate and make this adventure memorable!",
                "Welcome aboard, [BYSTANDER]! Your addition to the group is much appreciated. Let's support each other and strive for excellence!",
                "Hello, [BYSTANDER]! We're thrilled to have you join our team. Together, let's overcome any obstacles and achieve remarkable success!",
                "Great to have you with us, [BYSTANDER]! Your unique perspective and abilities will be a valuable asset. Let's work together and make this journey remarkable!",
                "Welcome, [BYSTANDER]! Your presence enriches our group. Let's combine our strengths and accomplish extraordinary things!",
                "Hello, [BYSTANDER]! We've been looking forward to having you in our group. Let's collaborate and make this adventure an unforgettable experience!",
                "Glad you could join us, [BYSTANDER]! Your skills make us even stronger for the challenges ahead. Let's support each other and succeed together!",
                "Welcome, [BYSTANDER]! Your joining adds a new dynamic to our group. Let's leverage our collective strengths and accomplish great things!",
                "Hey, [BYSTANDER]! We're excited to have you on board. Let's unite our efforts and make this adventure a resounding success!",
                "Glad to see you here, [BYSTANDER]! Your expertise will greatly contribute to our group's achievements. Let's work together and surpass all expectations!",
                "Welcome aboard, [BYSTANDER]! Your unique talents and skills will be invaluable to our group. Let's collaborate and create an unforgettable journey!",
                "Hello, [BYSTANDER]! We're delighted to have you join our ranks. Let's combine our abilities and make this adventure truly exceptional!",
                "Great to have you, [BYSTANDER]! Your presence strengthens our group. Let's support each other and conquer challenges with confidence!",
                "Welcome, [BYSTANDER]! Your joining fills us with optimism. Let's unite our efforts and make this adventure an extraordinary one!",
                "Hey, [BYSTANDER]! We're glad you've joined us. Let's work together, learn from each other, and achieve remarkable things as a team!"
            }
        },
        ["LEAVE"] = {
            ["NEMESIS"] = {
                "Farewell, [NEMESIS]! Your presence will be sorely missed. Wishing you the best in your future adventures!",
                "Thank you, [NEMESIS], for being part of our group. It was a pleasure playing alongside you. Good luck in your future endeavors!",
                "Sad to see you go, [NEMESIS]. Your contributions to the group were greatly appreciated. Best of luck in your future endeavors!",
                "Goodbye, [NEMESIS]! Your skills and camaraderie will be remembered. May your future adventures be filled with success!",
                "It's been a pleasure having you with us, [NEMESIS]. Thank you for your dedication and contributions. Best wishes in your future endeavors!",
                "Farewell, [NEMESIS]. Your presence enriched our group, and we're grateful for the time we spent together. Best of luck on your future adventures!",
                "Thank you, [NEMESIS], for the memorable moments we shared. You were a valuable member of our group. Wishing you all the best!",
                "Sad to see you leave, [NEMESIS]. Your skills and positive attitude were invaluable. May your future adventures be filled with triumphs!",
                "Goodbye, [NEMESIS]! You made a significant impact on our group, and we'll miss your contributions. Best of luck in your future endeavors!",
                "It's been an honor to have you as part of our group, [NEMESIS]. Thank you for your commitment and companionship. Best wishes on your future endeavors!",
                "Farewell, [NEMESIS]. We'll cherish the memories we created together. Thank you for your dedication and support. May your future adventures be extraordinary!",
                "Thank you, [NEMESIS], for your time and dedication to our group. Your contributions will be remembered. Best of luck in your future endeavors!",
                "Sad to see you go, [NEMESIS]. Your presence added value to our group, and we'll miss your company. Wishing you success and joy in your future adventures!",
                "Goodbye, [NEMESIS]! We appreciate the effort and enthusiasm you brought to our group. May your future endeavors be filled with triumph and happiness!",
                "It's been a pleasure playing with you, [NEMESIS]. Your skills and teamwork were remarkable. Best of luck on your future adventures!",
                "Farewell, [NEMESIS]. Your presence and contributions made our group stronger. We wish you all the best in your future endeavors!",
                "Thank you, [NEMESIS], for being a part of our group. Your positive energy and skills were invaluable. Best wishes for your future gaming endeavors!",
                "Sad to see you leave, [NEMESIS]. Your dedication and teamwork were greatly appreciated. May your future adventures be filled with excitement and success!",
                "Goodbye, [NEMESIS]! Your presence made a difference in our group, and we're grateful for the time we spent together. Best of luck in your future gaming endeavors!",
                "It's been a privilege to have you in our group, [NEMESIS]. Thank you for your commitment and contributions. May your future adventures be filled with triumph!",
                "Farewell, [NEMESIS]. Your camaraderie and skillset will be missed. Wishing you nothing but success and joy in your future gaming experiences!"
            },
            ["BYSTANDER"] = {
                "Farewell, [BYSTANDER]! We appreciate your time and contributions. Best of luck in your future gaming endeavors!",
                "Thank you, [BYSTANDER], for your dedication and teamwork. It was a pleasure having you in our group. Wishing you success and joy in your future adventures!",
                "Sad to see you go, [BYSTANDER]. Your presence made our group stronger. May your future gaming experiences be filled with excitement and triumphs!",
                "Goodbye, [BYSTANDER]! Your contributions and positive attitude were invaluable. We'll miss your company. Best of luck on your future gaming endeavors!",
                "It's been a pleasure having you with us, [BYSTANDER]. Thank you for your commitment and support. Wishing you the best in your future gaming experiences!",
                "Farewell, [BYSTANDER]. Your camaraderie and skills will be remembered. May your future adventures be filled with success and joy!",
                "Thank you, [BYSTANDER], for the wonderful moments we shared. Your dedication and positive energy were greatly appreciated. Best wishes in your future gaming endeavors!",
                "Sad to see you leave, [BYSTANDER]. Your contributions to our group were invaluable, and we'll miss your presence. May your future gaming experiences be exceptional!",
                "Goodbye, [BYSTANDER]! We're grateful for your time and efforts in our group. Best of luck in your future gaming endeavors!",
                "It's been a privilege playing with you, [BYSTANDER]. Your skills and teamwork were remarkable. Wishing you success and happiness in your future gaming experiences!",
                "Farewell, [BYSTANDER]. Your presence and contributions made our group stronger. We'll cherish the memories we created together. Best of luck in your future gaming endeavors!",
                "Thank you, [BYSTANDER], for your dedication and support. Your positive impact on our group will not be forgotten. May your future gaming experiences be filled with triumphs!",
                "Sad to see you go, [BYSTANDER]. Your teamwork and camaraderie were greatly appreciated. We'll miss having you in our group. Best of luck in your future gaming endeavors!",
                "Goodbye, [BYSTANDER]! Your commitment and positive attitude added value to our group. Wishing you success and happiness in your future gaming experiences!",
                "It's been a pleasure playing alongside you, [BYSTANDER]. Your contributions and companionship were remarkable. Best of luck on your future gaming endeavors!",
                "Farewell, [BYSTANDER]. We're grateful for your time and efforts in our group. May your future gaming experiences be filled with joy and triumphs!",
                "Thank you, [BYSTANDER], for being a part of our group. Your dedication and teamwork were exceptional. Best wishes for your future gaming endeavors!",
                "Sad to see you leave, [BYSTANDER]. Your presence and contributions enriched our group. We'll miss your company. May your future gaming experiences be filled with excitement and success!",
                "Goodbye, [BYSTANDER]! We appreciate your commitment and enthusiasm. Best of luck in your future gaming endeavors!",
                "It's been a privilege to have you in our group, [BYSTANDER]. Thank you for your time and contributions. May your future gaming experiences be filled with triumph and happiness!",
                "Farewell, [BYSTANDER]. Your camaraderie and positive energy will be missed. Wishing you nothing but success and joy in your future gaming experiences!"
            }
          }
    },
    ["CHALLENGE"] = {
        ["START"] = {
            ["NA"] = {
                "[NEMESIS] and [BYSTANDER], prepare yourselves for this +[KEYSTONELEVEL]. Your skills and dedication will lead us to victory!",
                "As we embark on this +[KEYSTONELEVEL] adventure, I have great confidence in both [NEMESIS] and [BYSTANDER]'s abilities. Together, we will conquer any obstacle!",
                "In this Mythic+ dungeon, we have an incredible team with [NEMESIS] and [BYSTANDER]. Your expertise will surely guide us to success. Let's show them what we're made of!",
                "[NEMESIS] and [BYSTANDER], the time has come to face this formidable +[KEYSTONELEVEL]. Your exceptional skills will be the key to our triumph. Let's give it our all!",
                "Brace yourselves, [NEMESIS] and [BYSTANDER], for the thrill of this +[KEYSTONELEVEL]. Your determination and proficiency will drive us forward. Together, we shall emerge victorious!",
                "As we step into this Mythic+ dungeon, I want to commend [NEMESIS] and [BYSTANDER] for their exceptional prowess. Together, we will conquer this +[KEYSTONELEVEL] and leave our mark!",
                "Attention, [NEMESIS] and [BYSTANDER]! The time has come to unleash your talents in this +[KEYSTONELEVEL]. Your contributions will be the catalysts for our success. Let's rise to the occasion!",
                "Welcome, [NEMESIS] and [BYSTANDER], to this thrilling Mythic+ adventure. I have great faith in your skills and believe that together, we can achieve juicy +[KEYSTONELEVEL] greatness!",
                "In this +[KEYSTONELEVEL], we have an extraordinary duo: [NEMESIS] and [BYSTANDER]. Your combined strengths will undoubtedly lead us to victory. Let's show the world what we're capable of!",
                "To my esteemed companions, [NEMESIS] and [BYSTANDER], let's embark on this +[KEYSTONELEVEL] with confidence. Your individual abilities will pave the way for our triumph. Together, we shall prevail!",
                "[NEMESIS] and [BYSTANDER], prepare to test your mettle in this +[KEYSTONELEVEL]. Your unwavering determination will set the stage for our success. Let's show them what we're made of!",
                "As we venture into this +[KEYSTONELEVEL], I want to acknowledge the skills of [NEMESIS] and [BYSTANDER]. Your dedication and expertise will lead us to victory. Let's conquer this challenge together!",
                "Bravo, [NEMESIS] and [BYSTANDER]! Together, we embark on this Mythic+ journey, armed with your remarkable talents. Let's face this +[KEYSTONELEVEL] head-on and emerge triumphant!",
                "Ladies and gentlemen, we have an exceptional team comprising [NEMESIS] and [BYSTANDER]. As we enter this +[KEYSTONELEVEL], let's leverage our collective strengths and create a legendary tale of victory!",
                "[NEMESIS] and [BYSTANDER], the time has come to face this daunting +[KEYSTONELEVEL] trial. I have full confidence in your abilities. Let's showcase our synergy and conquer this challenge with finesse!",
                "As the doors of this +[KEYSTONELEVEL] open, I salute the skills of [NEMESIS] and [BYSTANDER]. Your unwavering dedication will be the driving force behind our success. Let's make this journey an unforgettable one!",
                "Together, [NEMESIS] and [BYSTANDER], let's step into this +[KEYSTONELEVEL] with unwavering determination. Your exceptional abilities will shape our destiny. Let's surpass all expectations and emerge victorious!",
                "Brace yourselves, [NEMESIS] and [BYSTANDER], for this +[KEYSTONELEVEL] adventure that lies before us. Your talents are the foundation upon which our triumph will be built. Let's rise to the occasion and conquer this challenge together!",
                "In this +[KEYSTONELEVEL], we have an incredible duo: [NEMESIS] and [BYSTANDER]. Your unique strengths and capabilities will pave the way for our victory. Let's embrace the challenge and leave a mark that will be remembered!",
                "[NEMESIS] and [BYSTANDER], united we stand as we enter this +[KEYSTONELEVEL]. Your exceptional skills and determination will be the driving force behind our success. Let's surpass all obstacles and emerge as champions!",
                "As we venture into this +[KEYSTONELEVEL], I want to acknowledge the exceptional talents of [NEMESIS] and [BYSTANDER]. Your presence fills me with confidence that together, we will conquer this challenge and emerge victorious!",
            }
        },
        ["FAIL"] = {
            ["NA"] = {
                "Despite falling short in this challenging +[KEYSTONELEVEL], I'm grateful to [BYSTANDER] and [NEMESIS] for almost carrying me. It's no small feat to support me through such a demanding endeavor.",
                "My heartfelt thanks to [BYSTANDER] and [NEMESIS] for their exceptional efforts in this +[KEYSTONELEVEL]. They came incredibly close to carrying me through, showcasing their unwavering determination.",
                "While we didn't beat the timer in this demanding +[KEYSTONELEVEL], I'm immensely appreciative of [BYSTANDER] and [NEMESIS]. They almost carried me through the hardships, and their dedication was truly remarkable.",
                "Falling short of completing the +[KEYSTONELEVEL] within the time limit doesn't diminish my gratitude towards [BYSTANDER] and [NEMESIS]. Their almost successful attempt at carrying me through is commendable.",
                "Although I couldn't conquer this challenging +[KEYSTONELEVEL] in time, I want to express my deep appreciation for [BYSTANDER] and [NEMESIS]. They nearly carried me to victory, displaying exceptional skill and resilience.",
                "In this +[KEYSTONELEVEL], where carrying me is no easy task, [BYSTANDER] and [NEMESIS] came astonishingly close. Their almost successful efforts deserve high praise.",
                "While we didn't achieve our goal in this +[KEYSTONELEVEL], I'm grateful to [BYSTANDER] and [NEMESIS] for nearly carrying me through the arduous challenges. Their exceptional performance was truly remarkable.",
                "Kudos to [BYSTANDER] and [NEMESIS] for almost carrying me through this challenging +[KEYSTONELEVEL]. It's no small feat to support me through such demanding encounters.",
                "I want to express my heartfelt appreciation to [BYSTANDER] and [NEMESIS] for their outstanding efforts in this +[KEYSTONELEVEL]. They nearly carried me to victory, showcasing their exceptional skills.",
                "A special shoutout to [BYSTANDER] and [NEMESIS] for their remarkable performance in this +[KEYSTONELEVEL]. They almost carried me through the intense battles, and their dedication deserves praise.",
                "My deepest thanks go to [BYSTANDER] and [NEMESIS] for almost carrying me in this challenging +[KEYSTONELEVEL]. Their exceptional efforts and commitment were evident throughout.",
                "Though we didn't beat the timer in this demanding +[KEYSTONELEVEL], I want to acknowledge the incredible contribution of [BYSTANDER] and [NEMESIS]. They came astonishingly close to carrying me to success, and I'm sincerely grateful.",
                "Despite falling short of our goal in this challenging +[KEYSTONELEVEL], I'm indebted to [BYSTANDER] and [NEMESIS]. They almost carried me to victory, demonstrating their exceptional skills and unwavering support.",
                "A huge thank you to [BYSTANDER] and [NEMESIS] for their relentless efforts in this +[KEYSTONELEVEL]. They came incredibly close to carrying me through the treacherous encounters, and their support was invaluable.",
            },
        },
        ["SUCCESS"] = {
            ["NA"] = {
                "Kudos to the group for flawlessly carrying me through this +[KEYSTONELEVEL]! Special thanks to [NEMESIS] and [BYSTANDER] for their exceptional teamwork!",
                "Massive appreciation to the group that skillfully carried me through this +[KEYSTONELEVEL] with flawless timing. A big round of applause for [NEMESIS] and [BYSTANDER]!",
                "Huge shoutout to the amazing group that flawlessly carried me through this +[KEYSTONELEVEL]! Special thanks to [NEMESIS] and [BYSTANDER] for their remarkable performance!",
                "Heartfelt thank you to the exceptional group that expertly carried me through a +[KEYSTONELEVEL] with flawless timing. I'm deeply grateful for [NEMESIS] and [BYSTANDER]'s exceptional dedication!",
                "Immense appreciation for the outstanding group that flawlessly carried me through a +[KEYSTONELEVEL] with perfect timing. I'm truly grateful for [NEMESIS] and [BYSTANDER]'s remarkable support!",
                "Standing ovation for the remarkable group that skillfully carried me through a +[KEYSTONELEVEL] with flawless timing. A special shoutout to [NEMESIS] and [BYSTANDER] for their exceptional teamwork!",
                "Big round of applause for the amazing group that flawlessly carried me through this +[KEYSTONELEVEL] with perfect timing. Special thanks to [NEMESIS] and [BYSTANDER] for their outstanding support!",
                "Immense appreciation for the exceptional group that expertly carried me through a +[KEYSTONELEVEL] with flawless timing. I'm deeply grateful for [NEMESIS] and [BYSTANDER]'s invaluable contributions!",
                "Heartfelt thank you to the remarkable group that flawlessly carried me through a +[KEYSTONELEVEL] with impeccable timing. Kudos to [NEMESIS] and [BYSTANDER] for their outstanding teamwork!",
                "Massive thank you to the amazing group that skillfully carried me through a +[KEYSTONELEVEL] with perfect timing. Hats off to [NEMESIS] and [BYSTANDER] for their exceptional dedication!",
                "Immense appreciation for the outstanding group that flawlessly carried me through this +[KEYSTONELEVEL] with flawless timing. I'm truly grateful for [NEMESIS] and [BYSTANDER]'s remarkable performance!",
                "Standing ovation for the remarkable group that skillfully carried me through a +[KEYSTONELEVEL] with perfect timing. A special shoutout to [NEMESIS] and [BYSTANDER] for their exceptional teamwork!",
                "Big round of applause for the exceptional group that flawlessly carried me through this +[KEYSTONELEVEL] with flawless timing. I'm deeply grateful for [NEMESIS] and [BYSTANDER]'s invaluable contributions!",
                "Heartfelt thank you to the remarkable group that flawlessly carried me through this +[KEYSTONELEVEL] with impeccable timing. Kudos to [NEMESIS] and [BYSTANDER] for their outstanding teamwork!",
                "Massive thank you to the amazing group that skillfully carried me through a +[KEYSTONELEVEL] with perfect timing. Hats off to [NEMESIS] and [BYSTANDER] for their exceptional dedication!",
                "Immense appreciation for the outstanding group that flawlessly carried me through this +[KEYSTONELEVEL] with flawless timing. I'm truly grateful for [NEMESIS] and [BYSTANDER]'s remarkable performance!",
                "Standing ovation for the remarkable group that skillfully carried me through a +[KEYSTONELEVEL] with perfect timing. A special shoutout to [NEMESIS] and [BYSTANDER] for their exceptional teamwork!"
            }
        }
    },
    ["COMBATLOG"] = {
        ["INTERRUPT"] = {
            ["NEMESIS"] = {
                "[NEMESIS] waves their hand and interrupts [TARGET]'s [SPELL] with precision!",
                "[NEMESIS] shows off their magical prowess by disrupting [TARGET]'s [SPELL]!",
                "With a quick reflex, [NEMESIS] interrupts [TARGET]'s [SPELL] and leaves them spellbound!",
                "[NEMESIS] expertly silences [TARGET]'s [SPELL], stealing the show with their interruption!",
                "[NEMESIS] plays the role of the ultimate disruptor, cutting off [TARGET]'s [SPELL] with finesse!",
                "Behold the magic of [NEMESIS] as they interrupt [TARGET]'s [SPELL] with a flick of their wrist!",
                "[NEMESIS] outsmarts [TARGET] and halts their [SPELL] in its tracks!",
                "Witness the power of [NEMESIS] as they shatter [TARGET]'s [SPELL] with their interruption!",
                "[NEMESIS] shows no mercy as they interrupt [TARGET]'s [SPELL] and turn the tables on them!",
                "In a feat of magical dexterity, [NEMESIS] interrupts [TARGET]'s [SPELL] and throws them off balance!",
                "[NEMESIS] showcases their interrupting skills, leaving [TARGET] bewildered and their [SPELL] unfinished!",
                "With a cunning move, [NEMESIS] interrupts [TARGET]'s [SPELL], leaving them in disbelief!",
                "[NEMESIS] casts their interruption magic and leaves [TARGET] struggling to finish their [SPELL]!",
                "Marvel at the magical finesse of [NEMESIS] as they interrupt [TARGET]'s [SPELL] flawlessly!",
                "[NEMESIS] showcases their mastery of interruption, leaving [TARGET] speechless as their [SPELL] fizzles out!",
                "Watch in awe as [NEMESIS] thwarts [TARGET]'s [SPELL] with a well-timed interruption!",
                "With a decisive action, [NEMESIS] interrupts [TARGET]'s [SPELL], proving their magical superiority!",
                "Prepare for a surprise twist as [NEMESIS] skillfully interrupts [TARGET]'s [SPELL] and gains the upper hand!",
            },
            ["BYSTANDER"] = {
                "[BYSTANDER] leaps into action and interrupts [TARGET]'s [SPELL]!",
                "In a remarkable feat, [BYSTANDER] disrupts [TARGET]'s [SPELL] and throws them off balance!",
                "[BYSTANDER] shows off their interrupting skills, leaving [TARGET] in disbelief as their [SPELL] is halted!",
                "With lightning-fast reflexes, [BYSTANDER] silences [TARGET]'s [SPELL] and saves the day!",
                "[BYSTANDER] steals the spotlight by expertly interrupting [TARGET]'s [SPELL]!",
                "Behold the magical prowess of [BYSTANDER] as they halt [TARGET]'s [SPELL] with precision!",
                "[BYSTANDER] plays the role of the ultimate disruptor, cutting off [TARGET]'s [SPELL]!",
                "With a well-timed interruption, [BYSTANDER] thwarts [TARGET]'s [SPELL] and gains the upper hand!",
                "[BYSTANDER] channels their inner mage and interrupts [TARGET]'s [SPELL] flawlessly!",
                "Watch in awe as [BYSTANDER] puts a stop to [TARGET]'s [SPELL] with swift precision!",
                "[BYSTANDER] showcases their interrupting prowess, leaving [TARGET] in awe of their skill!",
                "With a determined look, [BYSTANDER] interrupts [TARGET]'s [SPELL] and turns the tide of battle!",
                "[BYSTANDER] rises to the occasion and interrupts [TARGET]'s [SPELL] with remarkable speed!",
                "Witness the power of [BYSTANDER] as they silence [TARGET]'s [SPELL] and seize control of the situation!",
                "[BYSTANDER] acts swiftly and interrupts [TARGET]'s [SPELL], leaving them in disbelief!",
                "Marvel at the interruption mastery of [BYSTANDER] as they flawlessly halt [TARGET]'s [SPELL]!",
                "[BYSTANDER] steps up and puts a stop to [TARGET]'s [SPELL], turning the tide of the battle!",
                "Prepare for a surprise twist as [BYSTANDER] interrupts [TARGET]'s [SPELL] and saves the day!",
            },
            ["SELF"] = {
                "I disrupt [TARGET]'s [SPELL], channeling the spirit of [NEMESIS]!",
                "With lightning reflexes, I thwart [TARGET]'s [SPELL] in an attempt to match [BYSTANDER]'s mastery!",
                "I showcase my own art of interruption by halting [TARGET]'s [SPELL], striving to keep pace with [NEMESIS]'s brilliance!",
                "Behold, my interruption prowess! I emulate [BYSTANDER]'s finesse in foiling [TARGET]'s [SPELL]!",
                "Witness my skillful interruption as I mirror [NEMESIS]'s expertise in countering [TARGET]'s [SPELL]!",
                "In perfect synchronization with [BYSTANDER]'s mastery, I halt [TARGET]'s [SPELL] with finesse!",
                "I emulate [NEMESIS]'s formidable interruption skill by swiftly thwarting [TARGET]'s [SPELL]!",
                "With precision and focus, I disrupt [TARGET]'s [SPELL], endeavoring to match [BYSTANDER]'s brilliance!",
                "I intervene and nullify [TARGET]'s [SPELL], attempting to rival [NEMESIS]'s expertise!",
                "Harnessing the spirit of [BYSTANDER], I flawlessly interrupt [TARGET]'s [SPELL]!",
                "I display my own interruption mastery, mirroring [NEMESIS]'s expertise in countering [TARGET]'s [SPELL]!",
                "With unrivaled finesse, I halt [TARGET]'s [SPELL] to emulate [BYSTANDER]'s unmatched interruption prowess!",
                "Witness my flawless interruption as I mirror [NEMESIS]'s impeccable skill in countering [TARGET]'s [SPELL]!",
                "In perfect synchronization with [BYSTANDER]'s interruption mastery, I expertly thwart [TARGET]'s [SPELL]!",
                "I emulate [NEMESIS]'s unparalleled interruption skill by swiftly halting [TARGET]'s [SPELL]!",
                "With unwavering precision, I disrupt [TARGET]'s [SPELL], striving to match [BYSTANDER]'s brilliance!",
                "I intervene and nullify [TARGET]'s [SPELL], endeavoring to rival [NEMESIS]'s expertise!",
                "Drawing inspiration from [BYSTANDER]'s interruption prowess, I flawlessly thwart [TARGET]'s [SPELL]!",
                "I showcase my own interruption mastery, mirroring [NEMESIS]'s unparalleled expertise in countering [TARGET]'s [SPELL]!",
                "With unrivaled finesse, I halt [TARGET]'s [SPELL] to emulate [BYSTANDER]'s unmatched interruption prowess!",
                "Witness my flawless interruption as I mirror [NEMESIS]'s impeccable skill in countering [TARGET]'s [SPELL]!",
                "In perfect synchronization with [BYSTANDER]'s interruption mastery, I expertly disrupt [TARGET]'s [SPELL]!",
                "I emulate [NEMESIS]'s unparalleled interruption skill by swiftly nullifying [TARGET]'s [SPELL]!",
                "With unwavering precision, I interrupt [TARGET]'s [SPELL], striving to match [BYSTANDER]'s brilliance!",
                "I intervene and flawlessly counter [TARGET]'s [SPELL], endeavoring to rival [NEMESIS]'s expertise!",
            }
        },
        ["FEAST"] = {
            ["NEMESIS"] = {
                "[NEMESIS] activates party mode and conjures a delicious [SPELL]! You're the life of the feast!",
                "Step aside, Master Chef! [NEMESIS] brings their culinary wizardry to the table with an exquisite [SPELL]!",
                "Prepare your taste buds for a flavor explosion! [NEMESIS] surprises us with a divine [SPELL]!",
                "[NEMESIS] turns up the heat and treats us to a mouthwatering [SPELL]! Time to satisfy our hunger!",
                "Behold! [NEMESIS] unveils their culinary masterpiece—a tantalizing [SPELL] that's pure bliss!",
                "Cue the applause and confetti! [NEMESIS] whips up a sensational [SPELL] that's fit for champions!",
                "Raise your glasses! [NEMESIS] is the feast master, serving up a sumptuous [SPELL] that ignites our senses!",
                "[NEMESIS] sprinkles magic into our gathering with a spellbinding [SPELL]! It's a feast of epic proportions!",
                "With a flourish, [NEMESIS] presents a culinary marvel—a dazzling [SPELL] that leaves us craving more!",
                "Cheers to [NEMESIS] for conjuring an enchanting [SPELL]! You've turned this feast into a magical experience!",
                "Incredible! [NEMESIS] surprises us all with an extraordinary [SPELL]! Your culinary skills are legendary!",
                "Prepare to be dazzled! [NEMESIS] unveils a show-stopping [SPELL] that takes our taste buds on a wild ride!",
                "[NEMESIS] dons the chef's hat and delivers a gastronomic delight—an unforgettable [SPELL]!",
                "Get ready for a feast fit for royalty! [NEMESIS] wows us with an exquisite [SPELL] that reigns supreme!",
                "All hail the feast master! [NEMESIS] transforms the table with a mouthwatering [SPELL] that's pure magic!",
                "[NEMESIS] unleashes their culinary prowess and presents a stunning [SPELL] that leaves us in awe!",
            },
            ["BYSTANDER"] = {
                "[BYSTANDER] activates party mode and provides a delicious [SPELL]! You're the feast MVP!",
                "Step aside, Gordon Ramsay! [BYSTANDER] unleashes their culinary skills with an amazing [SPELL]!",
                "Get ready for a taste sensation! [BYSTANDER] surprises us all with a mouthwatering [SPELL]!",
                "[BYSTANDER] turns up the flavor dial and treats us to an unforgettable [SPELL]! Prepare to be amazed!",
                "Behold the culinary genius of [BYSTANDER]! They unveil a delectable [SPELL] that's a true masterpiece!",
                "Give a round of applause as [BYSTANDER] presents their pièce de résistance—a sensational [SPELL]!",
                "Get ready to feast like never before! [BYSTANDER] brings their A-game with a tantalizing [SPELL]!",
                "[BYSTANDER] sprinkles magic into our gathering with a spellbinding [SPELL]! It's a culinary adventure!",
                "Prepare to be amazed by [BYSTANDER]'s culinary prowess! They unveil an extraordinary [SPELL] that delights!",
                "Cheers to [BYSTANDER] for conjuring a gastronomic marvel—a mouthwatering [SPELL] that's simply divine!",
                "Prepare to be blown away! [BYSTANDER] surprises us all with an incredible [SPELL] that leaves us in awe!",
                "[BYSTANDER] dons the chef's hat and delivers a flavor explosion—an unforgettable [SPELL] that impresses!",
                "Get ready for a feast fit for kings and queens! [BYSTANDER] wows us with an exquisite [SPELL] that reigns supreme!",
                "All hail the culinary master! [BYSTANDER] transforms the table with a mesmerizing [SPELL] that's pure delight!",
                "[BYSTANDER] unleashes their culinary creativity and presents a stunning [SPELL] that's a feast for the senses!",
            },
            ["SELF"] = {
                "I'm activating party mode with a scrumptious [SPELL]—dig in and savor the flavors!",
                "Ladies and gentlemen, behold! I present a feast fit for champions—a delectable [SPELL]!",
                "Get ready to feast like never before! I conjure an irresistible [SPELL] for all to enjoy!",
                "I unveil my culinary prowess with a mouthwatering [SPELL]—let the feast begin!",
                "Indulge in the finest culinary delight—a tantalizing [SPELL] I conjure for our enjoyment!",
                "Step right up and witness my culinary magic—a divine [SPELL] that will dazzle your taste buds!",
                "Attention, everyone! I've summoned a feast of epic proportions—a delightful [SPELL] awaits!",
                "Join me in this gastronomic adventure as I present a sensational [SPELL] to satisfy our appetites!",
                "I channel my inner chef to craft a masterpiece—a delectable [SPELL] that's pure bliss!",
                "Prepare to be amazed! I create a culinary wonder—a mesmerizing [SPELL] that enchants the senses!",
                "It's time to celebrate! I've conjured an enchanting [SPELL] that transforms this feast into magic!",
                "Cheers to me for bringing joy to the table! I offer a sumptuous [SPELL] that's a true delight!",
                "Raise your forks and toast to this moment—I present a feast like no other—a magnificent [SPELL]!",
                "Behold! I unleash my culinary artistry—a delectable [SPELL] that will make your taste buds dance!",
                "I take center stage as the feast maestro, delighting everyone with an exquisite [SPELL]—bon appétit!",
                "In the realm of flavors, I am the sorcerer—I conjure a mesmerizing [SPELL] for us all to enjoy!",
                "Embrace the magic of this moment—I provide a feast of wonders, an unforgettable [SPELL]!",
                "I am the culinary virtuoso, and I bestow upon you a divine gift—a delectable [SPELL] to feast upon!",
                "Let's embark on a culinary adventure together—I offer an extraordinary [SPELL] that tantalizes the senses!",
                "Prepare yourselves, for I unleash my culinary prowess—a magnificent [SPELL] that transcends ordinary feasts!",
            },
        },
        ["REFEAST"] = {
            ["NEMESIS"] = {
                "[NEMESIS] couldn't resist the temptation and conjured another [SPELL]. The more, the merrier, right?",
                "Oops! It seems [NEMESIS] got carried away and placed another [SPELL] right after someone else. Double the feast, double the fun!",
                "[NEMESIS] has a hearty appetite for feasts, placing another [SPELL] to keep the celebration going. Can't blame them for their enthusiasm!",
                "In the spirit of abundance, [NEMESIS] unwittingly summoned a second [SPELL]. Feasts are like potato chips—you can't have just one!",
                "Oh dear! [NEMESIS] didn't realize someone already conjured a [SPELL], but their enthusiasm knows no bounds. We're blessed with an extra feast!",
                "Leave it to [NEMESIS] to double the feast fun by placing another [SPELL]. Who can resist the allure of delicious food?",
                "It's a feast frenzy! [NEMESIS] couldn't hold back their excitement and conjured an extra [SPELL]. Feasting at its finest!",
                "[NEMESIS] must have sensed the need for more deliciousness and added another [SPELL] to the table. Feast on, my friends!",
                "Two feasts are better than one, right? [NEMESIS] placed an additional [SPELL]. It's a feast feast!",
                "Oopsie-doodle! [NEMESIS] got a bit overzealous and summoned another [SPELL]. Can't blame them—the more, the merrier!",
            },
            ["BYSTANDER"] = {
                "[BYSTANDER] joins the feast excitement a bit late and places a [SPELL]. Better late than never, right?",
                "In their eagerness to contribute, [BYSTANDER] mistakenly conjured a [SPELL] after someone else. The feast just got even grander!",
                "Oh, look! [BYSTANDER] adds their own touch to the feast by placing a [SPELL]. The more, the merrier!",
                "[BYSTANDER] might be fashionably late, but they bring extra joy by placing a [SPELL] alongside the existing feast. Let's celebrate!",
                "Joining the feast festivities, [BYSTANDER] inadvertently creates their own culinary masterpiece—a surprise [SPELL]!",
                "Oops! [BYSTANDER] didn't realize someone already placed a [SPELL], but their enthusiasm shines as they add another feast to the table.",
                "What's a feast without a little surprise? [BYSTANDER] conjures another [SPELL], enhancing the celebration!",
                "In their eagerness to contribute, [BYSTANDER] mistakenly places another [SPELL]. Feasting just got even more exciting!",
                "Extra feasting delight! [BYSTANDER] summons another [SPELL] to complement the existing feast. Enjoy the abundance!",
                "Feastception alert! [BYSTANDER] adds their own culinary creation—a delicious [SPELL] to accompany the feast.",
            },
            ["SELF"] = {
                "Oops! In my eagerness to contribute, I accidentally conjure another [SPELL] after someone else. Double the feast, double the enjoyment!",
                "Oh dear, I didn't notice someone already placed a [SPELL], but hey, can we ever have too much of a good thing? Feast on!",
                "In the spirit of abundance, I unwittingly summon a second [SPELL] after someone else's. Let's celebrate with an extra feast!",
                "Oopsie-doodle! My enthusiasm gets the better of me as I accidentally place another [SPELL]. Feast on, my friends!",
                "Leave it to me to double the feast fun by accidentally placing another [SPELL]. Can't resist the temptation of delicious food!",
                "Two feasts are better than one, right? I accidentally conjure an additional [SPELL]. It's a feast feast!",
                "Oops! In my excitement, I place another [SPELL] after someone else. Can't blame me—I love spreading joy through feasts!",
                "Joining in on the feast excitement, I mistakenly conjure a [SPELL] after someone else's. The more, the merrier!",
                "Feasting fervor takes over as I accidentally add another [SPELL] to the table. Let's indulge in the abundance!",
                "Oops! In my eagerness to contribute, I accidentally summon another [SPELL]. Let's make this feast even more memorable!",
            },
        },
        ["OLDFEAST"] = {
            ["NEMESIS"] = {
                "[NEMESIS] takes a trip down memory lane and conjures an old favorite [SPELL] for the feast. It's a delicious blast from the past!",
                "In a delightful twist, [NEMESIS] surprises everyone with an old-school [SPELL] for the feast. Nostalgia and scrumptiousness combined!",
                "Remembering the good times, [NEMESIS] brings back the flavors of the past with an old feast featuring a delectable [SPELL]. Yum!",
                "Bringing the taste of nostalgia, [NEMESIS] unveils an old feast, complete with an irresistible [SPELL]. The memories and flavors intertwine!",
                "Prepare to be transported to a bygone era as [NEMESIS] conjures an old feast, featuring a mouthwatering [SPELL]. Let the feasting commence!",
                "In a whimsical move, [NEMESIS] revives the spirit of the past with an old feast, showcasing a delightful [SPELL]. It's like a culinary time machine!",
                "[NEMESIS] breaks the norm and surprises everyone with an old feast, featuring a crowd-pleasing [SPELL]. It's a delightful culinary adventure!",
                "Stepping into the realm of nostalgia, [NEMESIS] treats the group to an old feast, complete with a beloved [SPELL]. The flavors of the past reignite!",
                "An unexpected twist awaits as [NEMESIS] places an old feast, featuring a beloved [SPELL]. It's a delectable surprise for the taste buds!",
                "Channeling the magic of the past, [NEMESIS] presents an old feast, where the centerpiece is a mouthwatering [SPELL]. Relish in the flavors of nostalgia!",
                "As time stands still, [NEMESIS] conjures an old feast, bringing back the cherished taste of [SPELL]. It's a culinary journey to days long gone!",
                "With a touch of enchantment, [NEMESIS] unveils an old feast, capturing the essence of nostalgia with a delightful [SPELL]. Relive the flavors of yore!",
                "In a whimsical flourish, [NEMESIS] surprises everyone with an old feast, featuring a treasured [SPELL]. It's a feast of fond memories and deliciousness!",
                "Unlocking the culinary secrets of the past, [NEMESIS] conjures an old feast, showcasing a beloved [SPELL]. It's a mouthwatering tribute to days gone by!",
                "Prepare to be captivated as [NEMESIS] summons an old feast, unveiling a time-honored [SPELL]. The flavors and stories intertwine in a delightful feast!",
                "In a stroke of genius, [NEMESIS] resurrects the taste of yesteryears with an old feast, featuring a crowd-favorite [SPELL]. It's a feast that ignites nostalgia!",
                "Brace yourselves for a feast of legends! [NEMESIS] conjures an old favorite [SPELL], transporting us all to a bygone era of culinary greatness!",
                "With a flick of the wrist, [NEMESIS] unveils an old feast, featuring a beloved [SPELL] that awakens memories of past adventures. Let the feast begin!",
                "In a culinary time warp, [NEMESIS] surprises the group with an old feast, adorned with a treasured [SPELL]. It's a feast that transcends time and delights the senses!",
                "Step into a realm of flavors long forgotten! [NEMESIS] presents an old feast, crafted with care and showcasing a nostalgic [SPELL]. Indulge in the magic of the past!",
                "The echoes of the past resound as [NEMESIS] conjures an old feast, featuring a legendary [SPELL]. It's a tantalizing journey back in time, filled with delicious nostalgia!",
            },
            ["BYSTANDER"] = {
                "With a touch of whimsy, [BYSTANDER] conjures an old feast, delighting everyone with a nostalgic [SPELL]. It's a feast of cherished memories!",
                "In a surprising move, [BYSTANDER] brings back the flavors of yesteryears with an old feast, featuring a delicious [SPELL]. It's a taste of nostalgia!",
                "[BYSTANDER] stirs up fond memories by placing an old feast, complete with a beloved [SPELL]. It's like reliving the good old days through deliciousness!",
                "Rekindling the magic of the past, [BYSTANDER] unveils an old feast, featuring a cherished [SPELL]. The group gathers to savor the flavors of nostalgia!",
                "In a burst of nostalgia, [BYSTANDER] surprises the group with an old feast, showcasing a beloved [SPELL]. It's a culinary journey back in time!",
                "Prepare to be enchanted as [BYSTANDER] conjures an old feast, featuring a treasured [SPELL]. It's a feast that brings back the warmth of memories!",
                "[BYSTANDER] adds a delightful twist to the feast by placing an old feast, featuring a crowd-favorite [SPELL]. It's a delicious blast from the past!",
                "Stepping into the realm of reminiscence, [BYSTANDER] treats everyone to an old feast, complete with an irresistible [SPELL]. Let the nostalgic feasting begin!",
                "An unexpected surprise awaits as [BYSTANDER] places an old feast, showcasing a beloved [SPELL]. It's a delightful journey into the flavors of the past!",
                "As memories flood the group, [BYSTANDER] conjures an old feast, featuring a treasured [SPELL]. It's a feast that takes us back to cherished moments!",
                "The spirit of the past comes alive as [BYSTANDER] unveils an old feast, celebrating nostalgia with a delectable [SPELL]. Let the taste of memories fill the air!",
                "Prepare for a mouthwatering journey through time! [BYSTANDER] surprises everyone with an old feast, featuring a legendary [SPELL] from days of yore!",
                "With a twinkle in their eye, [BYSTANDER] conjures an old feast, whisking everyone away to the flavors of yesteryears with a delightful [SPELL]. Enjoy the feast!",
                "In a tribute to the past, [BYSTANDER] presents an old feast, featuring a beloved [SPELL]. It's a culinary adventure that pays homage to treasured memories!",
                "Step into the realms of nostalgia as [BYSTANDER] unveils an old feast, graced with the flavors of the past and a cherished [SPELL]. Indulge in the taste of memories!",
                "Witness the magic of culinary history! [BYSTANDER] conjures an old feast, featuring a revered [SPELL]. It's a feast that invites us all to relive the legends!",
                "Brace yourselves for a feast like no other! [BYSTANDER] surprises the group with an old favorite [SPELL], invoking memories of glorious adventures past!",
                "Embrace the enchantment of bygone days as [BYSTANDER] conjures an old feast, adorned with a treasured [SPELL]. Let the feast take you on a nostalgic journey!",
                "In a delightful twist of fate, [BYSTANDER] resurrects the flavors of the past with an old feast, featuring a crowd-pleasing [SPELL]. It's a nostalgic delight!",
            },
            ["SELF"] = {
                "I'm embracing nostalgia and conjuring an old feast with a delicious [SPELL]. It's like a culinary time machine, taking us back to the good old days!",
                "In a burst of fond memories, I surprise everyone with an old feast, featuring a beloved [SPELL]. Let's savor the flavors of the past!",
                "With a touch of enchantment, I unveil an old feast, transporting us all to a bygone era of culinary greatness with a mouthwatering [SPELL]. Enjoy the feast!",
                "As time stands still, I conjure an old feast, bringing back the cherished taste of [SPELL]. It's a culinary journey to days long gone!",
                "Step into a realm of flavors long forgotten! I present an old feast, crafted with care and showcasing a nostalgic [SPELL]. Indulge in the magic of the past!",
                "The echoes of the past resound as I conjure an old feast, featuring a legendary [SPELL]. It's a tantalizing journey back in time, filled with delicious nostalgia!",
                "In a whimsical flourish, I surprise everyone with an old feast, featuring a treasured [SPELL]. It's a feast of fond memories and deliciousness!",
                "Unlocking the culinary secrets of the past, I conjure an old feast, showcasing a beloved [SPELL]. It's a mouthwatering tribute to days gone by!",
                "Prepare to be captivated as I summon an old feast, unveiling a time-honored [SPELL]. The flavors and stories intertwine in a delightful feast!",
                "In a stroke of genius, I resurrect the taste of yesteryears with an old feast, featuring a crowd-favorite [SPELL]. It's a feast that ignites nostalgia!",
                "Brace yourselves for a feast of legends! I conjure an old favorite [SPELL], transporting us all to a bygone era of culinary greatness!",
                "With a flick of the wrist, I unveil an old feast, featuring a beloved [SPELL] that awakens memories of past adventures. Let the feast begin!",
                "In a culinary time warp, I surprise the group with an old feast, adorned with a treasured [SPELL]. It's a feast that transcends time and delights the senses!",
                "Step into a realm of flavors long forgotten! I present an old feast, crafted with care and showcasing a nostalgic [SPELL]. Indulge in the magic of the past!",
                "The echoes of the past resound as I conjure an old feast, featuring a legendary [SPELL]. It's a tantalizing journey back in time, filled with delicious nostalgia!",
                "In a whimsical flourish, I surprise everyone with an old feast, featuring a treasured [SPELL]. It's a feast of fond memories and deliciousness!",
                "Unlocking the culinary secrets of the past, I conjure an old feast, showcasing a beloved [SPELL]. It's a mouthwatering tribute to days gone by!",
                "Prepare to be captivated as I summon an old feast, unveiling a time-honored [SPELL]. The flavors and stories intertwine in a delightful feast!",
                "In a stroke of genius, I resurrect the taste of yesteryears with an old feast, featuring a crowd-favorite [SPELL]. It's a feast that ignites nostalgia!",
                "Brace yourselves for a feast of legends! I conjure an old favorite [SPELL], transporting us all to a bygone era of culinary greatness!",
                "With a flick of the wrist, I unveil an old feast, featuring a beloved [SPELL] that awakens memories of past adventures. Let the feast begin!",
                "In a culinary time warp, I surprise the group with an old feast, adorned with a treasured [SPELL]. It's a feast that transcends time and delights the senses!",
            },
        },
    },
}

-- core.ai.taunts is the most aggressive set of phrases, and core.ai.praises is the most friendly
-- This array holds 10 tables, where index 1 is the most aggressive and index 10 is the most friendly
-- The array is used to determine the tone of the message based on the AI's personality
core.ai.phrases = {
    -- Index 1: Most aggressive (already defined in core.ai.taunts)
    core.ai.taunts,

    -- Index 2: Very aggressive, but slightly toned down
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Well, [NEMESIS], I see you're really excelling at getting us all killed. Bravo for your consistent incompetence.",
                    "Oh look, [NEMESIS] managed to turn a simple boss fight into a spectacular wipe. Your talent for failure is truly remarkable.",
                    "Congratulations, [NEMESIS], on single-handedly ensuring our defeat. It takes a special kind of skill to mess up this badly.",
                    "I'm in awe, [NEMESIS]. Your ability to consistently make the wrong decisions is nothing short of impressive.",
                    "Well done, [NEMESIS]. You've outdone yourself in the art of getting the entire group wiped. A true master of disaster.",
                    "Spectacular work, [NEMESIS]. I didn't think it was possible to fail so magnificently, but you've proven me wrong.",
                    "Ah, [NEMESIS], your unique blend of incompetence and bad luck never ceases to amaze me. Thanks for the wipe.",
                    "I must say, [NEMESIS], your commitment to failure is admirable. You really went above and beyond this time.",
                    "Bravo, [NEMESIS]! You've turned what should have been a simple fight into an absolute catastrophe. Impressive work.",
                    "Well, [NEMESIS], I hope you're proud. Your 'expert' gameplay just cost us all a repair bill. Thanks for nothing."
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Thanks for the stellar protection, [NEMESIS]. I always wanted to test the durability of the floor with my face.",
                    "Oh, am I dead? I couldn't tell with [NEMESIS]'s incredible healing keeping me so alive and well.",
                    "Well, [NEMESIS], I hope you're proud. Your 'expert' tanking just got me a personal tour of the afterlife.",
                    "Bravo, [NEMESIS]. Your defensive skills are so impressive, I decided to take a nap mid-fight. Permanently.",
                    "I must applaud your strategy, [NEMESIS]. Letting me die really adds an element of challenge to the fight.",
                    "Fantastic job, [NEMESIS]. Your healing is so effective, I'm now communing with the spirit world.",
                    "Well, [NEMESIS], I guess your definition of 'keeping the group alive' doesn't include me. How convenient.",
                    "Oh joy, I get to admire the floor up close, all thanks to [NEMESIS]'s impeccable protection skills.",
                    "I'm touched, [NEMESIS]. You cared so much about my wellbeing that you let me take a dirt nap.",
                    "Spectacular work, [NEMESIS]. Your tanking is so good, I decided to check out the respawn timer."
                },
                ["NEMESIS"] = {
                    "Oh no, [NEMESIS] is down! Whatever shall we do without their invaluable contribution to our failure?",
                    "Look everyone, [NEMESIS] has graciously decided to tank the floor. How considerate of them.",
                    "Ah, [NEMESIS] has fallen. I'm sure it was all part of their master plan to get us wiped.",
                    "Well, well, [NEMESIS] couldn't stay alive. I'm shocked, truly shocked. Who could have seen this coming?",
                    "Oh dear, we've lost [NEMESIS]. I suppose someone had to step up and show us how to die properly.",
                    "Congratulations, [NEMESIS]! You've mastered the art of dying at the most inconvenient time possible.",
                    "I'm impressed, [NEMESIS]. Your ability to find every deadly mechanic is truly unparalleled.",
                    "Well done, [NEMESIS]. Your death has really spiced up this fight. We were getting bored of staying alive.",
                    "Bravo, [NEMESIS]! Your dramatic death scene was the highlight of this encounter. Oscar-worthy performance.",
                    "Oh look, [NEMESIS] is taking a dirt nap. I guess they needed a break from all that 'intense' gameplay."
                },
                ["BYSTANDER"] = {
                    "Well, [BYSTANDER], at least you won't have to witness [NEMESIS]'s further attempts at 'playing' the game.",
                    "Rest in peace, [BYSTANDER]. At least you're spared from enduring more of [NEMESIS]'s spectacular failures.",
                    "My condolences, [BYSTANDER]. Falling victim to [NEMESIS]'s incompetence must be frustrating.",
                    "[BYSTANDER] is down. I guess even they couldn't survive the chaos unleashed by [NEMESIS]'s 'skills'.",
                    "Farewell, [BYSTANDER]. Your sacrifice in the face of [NEMESIS]'s ineptitude won't be forgotten.",
                    "Another one bites the dust. [BYSTANDER], you fought bravely against [NEMESIS]'s tide of failure.",
                    "[BYSTANDER] has fallen. I suppose even the best of us can't survive [NEMESIS]'s unique brand of 'teamwork'.",
                    "And there goes [BYSTANDER]. Seems like not even they could withstand the storm of incompetence from [NEMESIS].",
                    "Rest now, [BYSTANDER]. You've earned your respite from [NEMESIS]'s endless parade of mistakes.",
                    "[BYSTANDER] is out. I guess they drew the short straw in [NEMESIS]'s game of 'who dies first'."
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, [NEMESIS], try not to mess this up too badly. Though I'm not holding my breath.",
                    "Here we go. [NEMESIS], if you could avoid your usual disasters, that'd be great.",
                    "Boss time, everyone. [NEMESIS], please try to remember which end of your weapon to hold this time.",
                    "Let's do this. [NEMESIS], I expect nothing from you and I'm still prepared to be disappointed.",
                    "[NEMESIS], just... try not to get us all killed in the first 10 seconds, okay?",
                    "Brace yourselves, everyone. [NEMESIS] is about to show us new and exciting ways to fail.",
                    "Boss incoming. [NEMESIS], if you could just stand in the corner and do nothing, that'd be great.",
                    "Here we go again. [NEMESIS], surprise us all and try not to be a complete liability this time.",
                    "It's boss time. [NEMESIS], I'm begging you, please don't turn this into another circus act.",
                    "[NEMESIS], I have a crazy idea. How about you try not to screw everything up this time? Just for novelty's sake."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Well, [NEMESIS], I guess even a broken clock is right twice a day. Somehow, we managed to win despite you.",
                    "I'm shocked, [NEMESIS]. We actually succeeded. Don't let it go to your head, it was clearly a fluke.",
                    "Victory, against all odds. [NEMESIS], your attempts to sabotage us clearly weren't thorough enough this time.",
                    "We did it, no thanks to you, [NEMESIS]. I suppose you're slightly less useless than I thought.",
                    "Congratulations, everyone. [NEMESIS], you can stop looking confused now, yes, we actually won.",
                    "I can't believe it. We succeeded with [NEMESIS] in the group. The stars must have aligned or something.",
                    "Well, what do you know? [NEMESIS] didn't completely ruin everything for once. Mark this day in your calendars.",
                    "Against all odds and [NEMESIS]'s best efforts to the contrary, we've actually won. Miracles do happen.",
                    "I'm stunned. We've achieved victory despite [NEMESIS]'s presence. The universe must be playing a prank on us.",
                    "Well done, team. And [NEMESIS]... I suppose you were slightly less of a hindrance than usual. Progress, I guess?"
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Oh great, [NEMESIS] has joined. I guess we're going for the 'challenge mode' run today.",
                    "Well, well, if it isn't [NEMESIS]. I hope everyone's ready for an exercise in frustration.",
                    "Look who decided to grace us with their presence. [NEMESIS], here to provide comic relief as usual?",
                    "Brace yourselves, everyone. [NEMESIS] has joined, so expect the unexpected... and by that, I mean failure.",
                    "[NEMESIS] is here. I guess someone decided we weren't handicapped enough already.",
                    "Oh joy, [NEMESIS] has joined our merry band. I can already feel my will to live diminishing.",
                    "Well, if it isn't [NEMESIS]. I hope everyone's prepared for an eventful run... and not in a good way.",
                    "Great, [NEMESIS] is here. I suggest we all lower our expectations now to avoid disappointment later.",
                    "Attention everyone, [NEMESIS] has joined. Remember, it's not wiping if we call it 'tactical regrouping'.",
                    "[NEMESIS] has entered the chat. I hope everyone brought their patience, we're going to need it."
                },
                ["SELF"] = {
                    "Well, well, [NEMESIS], look who decided to join us. I hope you're ready to witness some actual skill.",
                    "Oh, [NEMESIS] is here. Try to keep up, if you can. Though I won't hold my breath.",
                    "Ah, [NEMESIS], so glad you could join us. Try not to slow us down too much, will you?",
                    "Well, if it isn't [NEMESIS]. I suppose someone has to be the before picture to my after.",
                    "Oh joy, [NEMESIS] has graced us with their presence. This should be... interesting.",
                    "Look who's here, it's [NEMESIS]. I hope you're prepared to be outshone in every possible way.",
                    "Ah, [NEMESIS], you've joined us. Try to learn something while you're here, won't you?",
                    "Well, [NEMESIS], I see you've decided to join. Try not to stand in the fire too much, okay?",
                    "Oh look, it's [NEMESIS]. I hope you brought your A-game. You're going to need it to keep up with me.",
                    "[NEMESIS] has joined the party. I guess someone needs to be here to make me look good by comparison."
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]. I hope you're ready for the [NEMESIS] show of incompetence.",
                    "Ah, [BYSTANDER] has joined us. Brace yourself for the unique experience of playing with [NEMESIS].",
                    "Greetings, [BYSTANDER]. You've chosen an... interesting time to join, with [NEMESIS] here and all.",
                    "Welcome aboard, [BYSTANDER]. I hope you have plenty of patience to deal with [NEMESIS]'s antics.",
                    "[BYSTANDER] has entered the fray. You picked a hell of a day to join, with [NEMESIS] in the group.",
                    "Hello, [BYSTANDER]. Fair warning: we have [NEMESIS] with us, so expect the unexpected.",
                    "Welcome, [BYSTANDER]. Don't let [NEMESIS]'s presence lower your expectations too much.",
                    "Ah, [BYSTANDER] has arrived. I hope you're prepared for the unique challenge of playing with [NEMESIS].",
                    "Greetings, [BYSTANDER]. You've joined just in time to witness [NEMESIS]'s special brand of 'skill'.",
                    "Welcome to the party, [BYSTANDER]. Just a heads up, we have [NEMESIS] here, so... good luck with that."
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "And there goes [NEMESIS]. I guess they finally realized they were out of their depth.",
                    "Oh look, [NEMESIS] is leaving. I guess the challenge of basic competence was too much.",
                    "Well, well, [NEMESIS] has decided to grace someone else with their 'skills'. Lucky them.",
                    "Ah, [NEMESIS] is departing. I'm sure we'll struggle to fill the void of constant failures.",
                    "Look at that, [NEMESIS] is off. I suppose even they have standards for how much they can embarrass themselves.",
                    "[NEMESIS] has left the building. I guess they got tired of being carried.",
                    "And [NEMESIS] makes their exit. I'm sure we'll miss their unique ability to find new ways to wipe.",
                    "There goes [NEMESIS]. I'm not sure whether to be relieved or disappointed at the loss of such prime entertainment.",
                    "Well, [NEMESIS] has decided to call it quits. I guess they finally realized they were the weak link.",
                    "And just like that, [NEMESIS] is gone. I'm sure their next group will be thrilled to have such a 'skilled' player."
                },
                ["BYSTANDER"] = {
                    "And there goes [BYSTANDER]. I guess they couldn't handle [NEMESIS]'s unique brand of 'teamwork'.",
                    "[BYSTANDER] has left the group. Can't blame them, dealing with [NEMESIS] is an acquired taste.",
                    "Well, we've lost [BYSTANDER]. I suppose even they have limits to how much [NEMESIS] they can tolerate.",
                    "Looks like [BYSTANDER] has had enough. [NEMESIS]'s 'skills' must have been too impressive to handle.",
                    "[BYSTANDER] has decided to leave. I guess watching [NEMESIS] in action was too much excitement for one day.",
                    "And there goes [BYSTANDER]. Seems like they've reached their quota of [NEMESIS]-induced facepalms.",
                    "[BYSTANDER] has left the building. Apparently, [NEMESIS]'s performance was too breathtaking to bear.",
                    "Well, [BYSTANDER] is out. Can't say I blame them, [NEMESIS] does have a way of testing one's patience.",
                    "Looks like [BYSTANDER] has called it quits. I suppose there's only so much [NEMESIS] one can take in a day.",
                    "And just like that, [BYSTANDER] is gone. I guess they weren't prepared for the full [NEMESIS] experience."
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], try not to deplete the key in the first pull, okay?",
                    "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], if you could avoid your usual disasters, that'd be great.",
                    "[KEYSTONELEVEL] time. [NEMESIS], please try to remember which end of your weapon to hold this time.",
                    "Let's do this [KEYSTONELEVEL]. [NEMESIS], I expect nothing from you and I'm still prepared to be disappointed.",
                    "[NEMESIS], just... try not to get us all killed in the first 10 seconds of this [KEYSTONELEVEL], okay?",
                    "Brace yourselves for this [KEYSTONELEVEL], everyone. [NEMESIS] is about to show us new and exciting ways to fail.",
                    "[KEYSTONELEVEL] incoming. [NEMESIS], if you could just stand in the corner and do nothing, that'd be great.",
                    "Here we go again with a [KEYSTONELEVEL]. [NEMESIS], surprise us all and try not to be a complete liability this time.",
                    "It's [KEYSTONELEVEL] time. [NEMESIS], I'm begging you, please don't turn this into another circus act.",
                    "[NEMESIS], I have a crazy idea for this [KEYSTONELEVEL]. How about you try not to screw everything up this time? Just for novelty's sake."
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "Well, [NEMESIS], you've outdone yourself. Failing a [KEYSTONELEVEL] is quite an achievement, even for you.",
                    "Congratulations, [NEMESIS]. Your 'expert' play just depleted our [KEYSTONELEVEL]. I hope you're proud.",
                    "And there goes our [KEYSTONELEVEL], thanks to [NEMESIS]'s stellar performance. I'm truly in awe of your ability to fail.",
                    "Well, [NEMESIS], I hope you're happy. Your unique talents just cost us a [KEYSTONELEVEL].",
                    "Bravo, [NEMESIS]. You've managed to turn a simple [KEYSTONELEVEL] into an epic disaster.",
                    "I'm impressed, [NEMESIS]. I didn't think it was possible to fail a [KEYSTONELEVEL] this spectacularly, but you proved me wrong.",
                    "Well done, [NEMESIS]. Your 'skills' just depleted our [KEYSTONELEVEL]. I guess we aimed too high thinking you could handle it.",
                    "Congratulations are in order, [NEMESIS]. You've single-handedly ensured the failure of our [KEYSTONELEVEL].",
                    "I'm in awe, [NEMESIS]. Your ability to sabotage a [KEYSTONELEVEL] is truly unparalleled.",
                    "Well, [NEMESIS], you've really outdone yourself this time. Failing a [KEYSTONELEVEL] in record time must be your new specialty."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Well, color me surprised. We actually completed the [KEYSTONELEVEL], despite [NEMESIS]'s best efforts to sabotage us.",
                    "I can't believe it. We finished the [KEYSTONELEVEL] with [NEMESIS] in the group. The stars must have aligned or something.",
                    "Against all odds and [NEMESIS]'s 'contributions', we've completed the [KEYSTONELEVEL]. Miracles do happen, I suppose.",
                    "Well, what do you know? We managed to time the [KEYSTONELEVEL] even with [NEMESIS] dragging us down. Impressive teamwork, everyone else.",
                    "I'm shocked. We actually succeeded in timing the [KEYSTONELEVEL]. [NEMESIS], your attempts to hinder us clearly weren't thorough enough.",
                    "Unbelievable. We timed the [KEYSTONELEVEL] with [NEMESIS] in tow. I guess even a broken clock is right twice a day.",
                    "Well, I'll be damned. We completed the [KEYSTONELEVEL] in time. [NEMESIS], you were slightly less of a burden than usual. Progress, I suppose?",
                    "I'm stunned. We've actually timed the [KEYSTONELEVEL] despite [NEMESIS]'s presence. The universe must be playing a prank on us.",
                    "Incredible. We've succeeded in timing the [KEYSTONELEVEL]. [NEMESIS], your usual incompetence must have taken a day off.",
                    "Well, this is unexpected. We've timed the [KEYSTONELEVEL]. [NEMESIS], I guess your 'unique playstyle' didn't completely ruin things for once."
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "Oh look, I had to interrupt [TARGET]'s [SPELL]. [NEMESIS], were you too busy napping to handle it?",
                    "I just interrupted [TARGET]'s [SPELL]. [NEMESIS], I know it's hard, but do try to keep up.",
                    "Wow, I actually had to stop [TARGET]'s [SPELL] myself. [NEMESIS], are your interrupt keys broken?",
                    "There goes [TARGET]'s [SPELL], interrupted by yours truly. [NEMESIS], feel free to join in anytime.",
                    "I guess I'll handle [TARGET]'s [SPELL] since [NEMESIS] is too busy sight-seeing or whatever.",
                    "Oh, was I supposed to leave [TARGET]'s [SPELL] for you, [NEMESIS]? My bad, I forgot you were 'contributing'.",
                    "Look at that, I interrupted [TARGET]'s [SPELL]. [NEMESIS], this is what being useful looks like, take notes.",
                    "I'll just take care of [TARGET]'s [SPELL], shall I? [NEMESIS], don't strain yourself or anything.",
                    "Interrupting [TARGET]'s [SPELL] all by myself. [NEMESIS], your lack of assistance is truly impressive.",
                    "[TARGET]'s [SPELL] stopped, courtesy of me. [NEMESIS], feel free to pretend you were about to do it."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually interrupted [TARGET]'s [SPELL]. I guess even a blind squirrel finds a nut occasionally.",
                    "Oh, look at that. [NEMESIS] managed to interrupt [TARGET]'s [SPELL]. Did you trip and fall on your interrupt key?",
                    "I'm shocked. [NEMESIS] interrupted [TARGET]'s [SPELL]. Quick, someone check if hell has frozen over.",
                    "Wow, [NEMESIS] interrupted [TARGET]'s [SPELL]. I didn't think you even knew what an interrupt was.",
                    "Hold the presses! [NEMESIS] just interrupted [TARGET]'s [SPELL]. This must be what they call a 'blue moon' event.",
                    "I can't believe my eyes. [NEMESIS] actually interrupted [TARGET]'s [SPELL]. Are you feeling alright?",
                    "Is this real life? [NEMESIS] interrupted [TARGET]'s [SPELL]. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] interrupted [TARGET]'s [SPELL]. I guess miracles do happen.",
                    "Alert the media! [NEMESIS] just interrupted [TARGET]'s [SPELL]. Truly a momentous occasion.",
                    "I must be dreaming. [NEMESIS] interrupted [TARGET]'s [SPELL]. Quick, someone pinch me!"
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "Oh look, I had to dispel that myself. [NEMESIS], were you too busy drooling to notice?",
                    "Guess I'll handle the dispels since [NEMESIS] is too preoccupied with being useless.",
                    "There goes another dispel from me. [NEMESIS], feel free to chip in anytime this century.",
                    "I suppose I'll take care of the dispelling. We can't expect [NEMESIS] to multitask, can we?",
                    "Another dispel done by yours truly. [NEMESIS], this is what being helpful looks like, take notes.",
                    "Oh, was I supposed to leave that for you to dispel, [NEMESIS]? My bad, I forgot you were 'contributing'.",
                    "Look at that, I'm dispelling again. [NEMESIS], don't strain yourself or anything.",
                    "Dispelling all by myself. [NEMESIS], your lack of assistance is truly awe-inspiring.",
                    "I'll just handle all the dispels, shall I? [NEMESIS], please, continue to excel at doing absolutely nothing.",
                    "Another one dispelled. [NEMESIS], feel free to pretend you were about to do it."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually dispelled something. I guess even a broken clock is right twice a day.",
                    "Oh, look at that. [NEMESIS] managed a dispel. Did you accidentally press the right button for once?",
                    "I'm shocked. [NEMESIS] dispelled something. Quick, someone check if pigs are flying outside.",
                    "Wow, [NEMESIS] actually used dispel. I didn't think you even had it on your action bars.",
                    "Hold everything! [NEMESIS] just dispelled. This must be what they call a 'once in a blue moon' event.",
                    "I can't believe my eyes. [NEMESIS] actually dispelled something. Are you feeling alright?",
                    "Is this the twilight zone? [NEMESIS] used dispel. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] dispelled. I guess miracles do happen... very, very rarely.",
                    "Stop the presses! [NEMESIS] just used dispel. Truly a momentous occasion.",
                    "I must be hallucinating. [NEMESIS] dispelled something. Quick, someone pinch me!"
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "Oh look, I had to CC that myself. [NEMESIS], were you too busy counting your fingers to notice?",
                    "Guess I'll handle the CC since [NEMESIS] is too preoccupied with being a spectacular waste of space.",
                    "There goes another CC from me. [NEMESIS], feel free to contribute anytime this expansion.",
                    "I suppose I'll take care of the crowd control. We can't expect [NEMESIS] to understand basic game mechanics, can we?",
                    "Another mob CC'd by yours truly. [NEMESIS], this is what being useful looks like, not that you'd know.",
                    "Oh, was I supposed to leave that for you to CC, [NEMESIS]? My bad, I forgot you were 'playing' with us.",
                    "Look at that, I'm CCing again. [NEMESIS], don't hurt yourself thinking about helping or anything.",
                    "Crowd controlling all by myself. [NEMESIS], your ability to avoid being helpful is truly impressive.",
                    "I'll just handle all the CC, shall I? [NEMESIS], please, continue to excel at being completely useless.",
                    "Another one CC'd. [NEMESIS], feel free to pretend you were about to do it, if you even know how."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually CC'd something. I guess monkeys can be trained after all.",
                    "Oh, look at that. [NEMESIS] managed to CC. Did you accidentally click the right ability while face-rolling your keyboard?",
                    "I'm shocked. [NEMESIS] CC'd something. Quick, someone check if the sun is rising in the west.",
                    "Wow, [NEMESIS] actually used CC. I didn't think you even knew what those letters stood for.",
                    "Hold everything! [NEMESIS] just CC'd a mob. This must be what they call an 'act of God'.",
                    "I can't believe my eyes. [NEMESIS] actually CC'd something. Did someone hack your account?",
                    "Is this real life? [NEMESIS] used CC. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] CC'd a mob. I guess even a blind squirrel finds a nut once in a while.",
                    "Alert the media! [NEMESIS] just used CC. Truly a sign of the apocalypse.",
                    "I must be dreaming. [NEMESIS] CC'd something. Quick, someone slap me back to reality!"
                }
            }
        }
    },

    -- Index 3: Aggressive, but less so than index 2
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Well, [NEMESIS], that was... something. Not quite the victory we were hoping for, but definitely memorable.",
                    "I see [NEMESIS] is really pushing the boundaries of how not to do this fight. Innovative, I'll give you that.",
                    "[NEMESIS], I'm starting to think you might need a refresher on boss mechanics. Just a hunch.",
                    "That was an interesting strategy, [NEMESIS]. I especially liked the part where we all died.",
                    "Well, [NEMESIS], I suppose that's one way to approach the fight. Not a successful way, but a way nonetheless.",
                    "Congratulations, [NEMESIS], you've found yet another creative way for us to wipe. Your talent knows no bounds.",
                    "[NEMESIS], I'm impressed. I didn't think it was possible to mess up quite that spectacularly.",
                    "Well, that was... educational. [NEMESIS], you've shown us all how not to do this fight. Thanks for that.",
                    "I have to hand it to you, [NEMESIS]. Your ability to find new and exciting ways to fail is truly remarkable.",
                    "[NEMESIS], I'm curious. Is this part of some elaborate plan to see how many times we can wipe in one night?"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Hm, [NEMESIS], I think there might be a flaw in your 'let the healer die' strategy.",
                    "Well, this is cozy. Thanks for the impromptu nap, [NEMESIS]. Really appreciated.",
                    "[NEMESIS], when I said I needed a break, this isn't quite what I had in mind.",
                    "Oh good, I needed to check the durability on my armor anyway. Thanks for the opportunity, [NEMESIS].",
                    "Well, [NEMESIS], I hope you're happy. I've always wanted to study the floor patterns up close.",
                    "[NEMESIS], I'm beginning to think your definition of 'protection' might need some work.",
                    "Ah, so this is what the afterlife looks like. Thanks for the tour, [NEMESIS].",
                    "I see you've mastered the 'everyone for themselves' tanking style, [NEMESIS]. How... innovative.",
                    "Well, [NEMESIS], I guess this is one way to avoid mechanics. Not the way I'd choose, but to each their own.",
                    "[NEMESIS], when I said I needed more excitement in my life, this isn't quite what I meant."
                },
                ["NEMESIS"] = {
                    "Oh, [NEMESIS] is taking a dirt nap. How unexpectedly... expected.",
                    "Look at [NEMESIS], always eager to greet the floor. Such enthusiasm.",
                    "Well, there goes [NEMESIS]. I'm sure it was all part of some grand plan... right?",
                    "And down goes [NEMESIS]. I'd say I'm surprised, but let's not kid ourselves.",
                    "[NEMESIS] seems to have misunderstood the concept of 'floor tanking'. Interesting interpretation.",
                    "Oh look, [NEMESIS] has decided to inspect the floor up close. How... thorough of them.",
                    "Well, [NEMESIS] certainly knows how to make an exit. Dramatic, if not particularly helpful.",
                    "I see [NEMESIS] is trying out the 'play dead' strategy. Bold move, let's see if it pays off.",
                    "And there goes [NEMESIS], leading by example... of what not to do.",
                    "[NEMESIS] seems to have a unique interpretation of 'surviving the fight'. Interesting approach."
                },
                ["BYSTANDER"] = {
                    "Looks like [BYSTANDER] couldn't handle the excitement of [NEMESIS]'s... unique playstyle.",
                    "Well, [BYSTANDER] is down. I guess [NEMESIS]'s performance was too breathtaking to bear.",
                    "And there goes [BYSTANDER]. I suppose there's only so much [NEMESIS]-induced chaos one can take.",
                    "[BYSTANDER] has fallen. I guess they drew the short straw in [NEMESIS]'s game of 'who survives'.",
                    "Oh dear, we've lost [BYSTANDER]. [NEMESIS]'s 'strategy' claims another victim.",
                    "Well, [BYSTANDER] is out. Seems like they couldn't keep up with [NEMESIS]'s... innovative tactics.",
                    "Farewell, [BYSTANDER]. Your sacrifice in the face of [NEMESIS]'s gameplay won't be forgotten.",
                    "[BYSTANDER] has left us. I guess they weren't prepared for the full [NEMESIS] experience.",
                    "And [BYSTANDER] bites the dust. [NEMESIS]'s influence strikes again.",
                    "Rest in peace, [BYSTANDER]. At least you're spared from witnessing more of [NEMESIS]'s performance."
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, [NEMESIS], let's see what interesting interpretation of the mechanics you have for us this time.",
                    "Here we go again. [NEMESIS], try to surprise us by doing something right for a change.",
                    "Boss time, everyone. [NEMESIS], remember: the goal is to defeat the boss, not yourself.",
                    "Let's do this. [NEMESIS], maybe this time you'll impress us with your sudden grasp of basic gameplay.",
                    "[NEMESIS], just... try to stay alive for more than 30 seconds this time, okay?",
                    "Brace yourselves, everyone. [NEMESIS] is about to show us their unique interpretation of 'helping'.",
                    "Boss incoming. [NEMESIS], let's see if you can break your personal record of mistakes per minute.",
                    "Here we go again. [NEMESIS], try not to redefine the meaning of 'failure' this time.",
                    "It's boss time. [NEMESIS], I'm curious to see what new and exciting ways you'll find to complicate this.",
                    "[NEMESIS], I have a wild idea. How about trying to follow the actual strategy this time?"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Well, [NEMESIS], I guess your unique approach didn't completely doom us this time. Progress, I suppose.",
                    "I'm pleasantly surprised, [NEMESIS]. We actually succeeded despite... whatever it was you were doing.",
                    "Victory, against the odds. [NEMESIS], your attempts to 'help' weren't as detrimental as usual.",
                    "We did it, and [NEMESIS] didn't single-handedly cause our downfall. It's a day for the history books.",
                    "Congratulations, everyone. [NEMESIS], your performance was... less disastrous than anticipated.",
                    "I can't believe it. We succeeded with [NEMESIS] in the group. The universe must have glitched.",
                    "Well, what do you know? [NEMESIS] didn't completely sabotage our efforts. Small victories, I guess.",
                    "Against all expectations, we've won. [NEMESIS], your... contribution didn't ruin everything. Shocking.",
                    "I'm genuinely surprised. We've achieved victory despite [NEMESIS]'s best efforts to the contrary.",
                    "Well done, team. And [NEMESIS]... I suppose you were slightly less of a liability than usual. Baby steps."
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Oh look, [NEMESIS] has joined. This should make things... interesting.",
                    "Well, well, if it isn't [NEMESIS]. I hope everyone's ready for an eventful run.",
                    "Look who decided to grace us with their presence. [NEMESIS], here to spice things up as usual?",
                    "Brace yourselves, everyone. [NEMESIS] has joined, so expect the unexpected.",
                    "[NEMESIS] is here. I guess we were looking for an extra challenge.",
                    "Oh joy, [NEMESIS] has joined our group. This should be... an experience.",
                    "Well, if it isn't [NEMESIS]. I hope everyone's prepared for an interesting run.",
                    "Great, [NEMESIS] is here. I suggest we all brace for impact.",
                    "Attention everyone, [NEMESIS] has joined. Remember, it's not a wipe if we call it a 'tactical reset'.",
                    "[NEMESIS] has entered the chat. I hope everyone brought their patience, we might need it."
                },
                ["SELF"] = {
                    "Well, well, [NEMESIS], fancy meeting you here. Try to keep up, will you?",
                    "Oh, [NEMESIS] is here. This should be... enlightening.",
                    "Ah, [NEMESIS], so glad you could join us. Let's see if you can impress me this time.",
                    "Well, if it isn't [NEMESIS]. I look forward to seeing your... unique approach to gameplay.",
                    "Oh joy, [NEMESIS] has graced us with their presence. This should be interesting.",
                    "Look who's here, it's [NEMESIS]. I hope you're ready for a lesson in how this is really done.",
                    "Ah, [NEMESIS], you've joined us. Try to learn something while you're here, won't you?",
                    "Well, [NEMESIS], I see you've decided to join. Let's hope you've improved since last time.",
                    "Oh look, it's [NEMESIS]. I hope you brought your A-game. You're going to need it.",
                    "[NEMESIS] has joined the party. This should be an... educational experience for you."
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]. Just a heads up, we have [NEMESIS] with us. It should be... interesting.",
                    "Ah, [BYSTANDER] has joined us. Brace yourself, [NEMESIS] is here too.",
                    "Greetings, [BYSTANDER]. Fair warning: [NEMESIS] is part of this group. Proceed with caution.",
                    "Welcome aboard, [BYSTANDER]. Just so you know, [NEMESIS] is here. It might get... eventful.",
                    "[BYSTANDER] has entered the fray. Hope you're ready for the [NEMESIS] experience.",
                    "Hello, [BYSTANDER]. Just a quick note: we have [NEMESIS] with us, so expect the unexpected.",
                    "Welcome, [BYSTANDER]. Don't let [NEMESIS]'s presence put you off. We'll manage... somehow.",
                    "Ah, [BYSTANDER] has arrived. Prepare yourself for the unique challenge of playing with [NEMESIS].",
                    "Greetings, [BYSTANDER]. You've joined just in time to witness [NEMESIS]'s... interesting gameplay.",
                    "Welcome to the party, [BYSTANDER]. Just a heads up, we have [NEMESIS] here. It should be... entertaining."
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "And there goes [NEMESIS]. I guess they decided we were too much of a challenge.",
                    "Oh look, [NEMESIS] is leaving. I suppose the concept of teamwork was too complex.",
                    "Well, well, [NEMESIS] has decided to grace someone else with their presence. Lucky them.",
                    "Ah, [NEMESIS] is departing. I'm sure we'll manage to soldier on without their... unique contributions.",
                    "Look at that, [NEMESIS] is off. I guess even they have limits to how much they can handle.",
                    "[NEMESIS] has left the building. I'm sure their next group will be... interested to have them.",
                    "And [NEMESIS] makes their exit. I'm sure we'll find some way to cope without them.",
                    "There goes [NEMESIS]. I'm not sure whether to be relieved or concerned for their next group.",
                    "Well, [NEMESIS] has decided to call it quits. I suppose we were too much for them to handle.",
                    "And just like that, [NEMESIS] is gone. Their next group is in for quite an... experience."
                },
                ["BYSTANDER"] = {
                    "And there goes [BYSTANDER]. I guess [NEMESIS]'s unique gameplay style was too much to handle.",
                    "[BYSTANDER] has left the group. Can't blame them, playing with [NEMESIS] is an acquired taste.",
                    "Well, we've lost [BYSTANDER]. I suppose even they have limits to how much [NEMESIS] they can tolerate.",
                    "Looks like [BYSTANDER] has had enough. [NEMESIS]'s... performance must have been too overwhelming.",
                    "[BYSTANDER] has decided to leave. I guess experiencing [NEMESIS] in action was quite enough for one day.",
                    "And there goes [BYSTANDER]. Seems like they've reached their quota of [NEMESIS]-induced excitement.",
                    "[BYSTANDER] has left the building. Apparently, [NEMESIS]'s gameplay was a bit too thrilling.",
                    "Well, [BYSTANDER] is out. Can't say I blame them, [NEMESIS] does have a way of making things... interesting.",
                    "Looks like [BYSTANDER] has called it quits. I suppose there's only so much [NEMESIS] one can take in a day.",
                    "And just like that, [BYSTANDER] is gone. I guess they weren't quite prepared for the full [NEMESIS] experience."
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], try not to make it too... exciting, okay?",
                    "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], let's see if you can surprise us with some competence.",
                    "[KEYSTONELEVEL] time. [NEMESIS], remember: the objective is to complete it, not to find new ways to fail.",
                    "Let's do this [KEYSTONELEVEL]. [NEMESIS], I'm cautiously optimistic about your performance. Don't prove me wrong.",
                    "[NEMESIS], just... try to keep up with the rest of us in this [KEYSTONELEVEL], alright?",
                    "Brace yourselves for this [KEYSTONELEVEL], everyone. [NEMESIS] is about to show us their unique interpretation of 'helping'.",
                    "[KEYSTONELEVEL] incoming. [NEMESIS], let's see if you can break your personal record of not messing up.",
                    "Here we go again with a [KEYSTONELEVEL]. [NEMESIS], try to impress us by not being a liability this time.",
                    "It's [KEYSTONELEVEL] time. [NEMESIS], I'm curious to see what interesting approach you'll take this time.",
                    "[NEMESIS], I have a wild idea for this [KEYSTONELEVEL]. How about trying to follow the actual strategy this time?"
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "Well, [NEMESIS], that was certainly an... interesting approach to depleting our [KEYSTONELEVEL].",
                    "Congratulations, [NEMESIS]. Your unique strategy just cost us our [KEYSTONELEVEL]. I hope you're proud.",
                    "And there goes our [KEYSTONELEVEL], thanks to [NEMESIS]'s creative interpretation of the mechanics.",
                    "Well, [NEMESIS], I hope you're satisfied. Your... performance just depleted our [KEYSTONELEVEL].",
                    "Bravo, [NEMESIS]. You've managed to turn a simple [KEYSTONELEVEL] into quite an adventure.",
                    "I'm impressed, [NEMESIS]. I didn't think it was possible to fail a [KEYSTONELEVEL] quite like that, but you proved me wrong.",
                    "Well done, [NEMESIS]. Your 'skills' just depleted our [KEYSTONELEVEL]. I guess it was too much to hope for success.",
                    "Congratulations are in order, [NEMESIS]. You've made this [KEYSTONELEVEL] a truly memorable experience... not in a good way.",
                    "I'm in awe, [NEMESIS]. Your ability to complicate a [KEYSTONELEVEL] is truly something to behold.",
                    "Well, [NEMESIS], you've really outdone yourself this time. Failing a [KEYSTONELEVEL] in such spectacular fashion must take real talent."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Well, color me surprised. We actually completed the [KEYSTONELEVEL], and [NEMESIS] didn't completely ruin it.",
                    "I can't believe it. We finished the [KEYSTONELEVEL] with [NEMESIS] in the group. Wonders never cease.",
                    "Against all odds and despite [NEMESIS]'s... interesting choices, we've completed the [KEYSTONELEVEL]. Miracles do happen.",
                    "Well, what do you know? We managed to time the [KEYSTONELEVEL] even with [NEMESIS] along for the ride. Impressive work, everyone else.",
                    "I'm pleasantly surprised. We actually succeeded in timing the [KEYSTONELEVEL]. [NEMESIS], your... contribution wasn't as detrimental as I feared.",
                    "Unbelievable. We timed the [KEYSTONELEVEL] with [NEMESIS] in tow. I guess even a broken clock is right twice a day.",
                    "Well, I'll be. We completed the [KEYSTONELEVEL] in time. [NEMESIS], you were... less of an obstacle than usual. Progress, I suppose?",
                    "I'm genuinely impressed. We've actually timed the [KEYSTONELEVEL] despite [NEMESIS]'s presence. The stars must have aligned.",
                    "Incredible. We've succeeded in timing the [KEYSTONELEVEL]. [NEMESIS], your performance was... less disastrous than anticipated.",
                    "Well, this is unexpected. We've timed the [KEYSTONELEVEL]. [NEMESIS], I guess your 'unique approach' didn't completely derail us this time."
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "Oh look, I had to interrupt [TARGET]'s [SPELL]. [NEMESIS], were you taking a scenic tour of the dungeon?",
                    "I just interrupted [TARGET]'s [SPELL]. [NEMESIS], I know it's challenging, but do try to keep up.",
                    "Wow, I actually had to stop [TARGET]'s [SPELL] myself. [NEMESIS], are your reflexes on a coffee break?",
                    "There goes [TARGET]'s [SPELL], interrupted by yours truly. [NEMESIS], feel free to join the fight anytime.",
                    "I guess I'll handle [TARGET]'s [SPELL] since [NEMESIS] is busy... doing whatever it is they do.",
                    "Oh, was I supposed to leave [TARGET]'s [SPELL] for you, [NEMESIS]? My bad, I forgot you were here.",
                    "Look at that, I interrupted [TARGET]'s [SPELL]. [NEMESIS], this is what being helpful looks like, in case you were wondering.",
                    "I'll just take care of [TARGET]'s [SPELL], shall I? [NEMESIS], don't strain yourself or anything.",
                    "Interrupting [TARGET]'s [SPELL] all by myself. [NEMESIS], your consistent lack of assistance is truly something.",
                    "[TARGET]'s [SPELL] stopped, courtesy of me. [NEMESIS], feel free to pretend you were about to do it."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually interrupted [TARGET]'s [SPELL]. I guess miracles do happen occasionally.",
                    "Oh, look at that. [NEMESIS] managed to interrupt [TARGET]'s [SPELL]. Did you accidentally press the right button?",
                    "I'm pleasantly surprised. [NEMESIS] interrupted [TARGET]'s [SPELL]. Maybe there's hope for you yet.",
                    "Wow, [NEMESIS] interrupted [TARGET]'s [SPELL]. I didn't think you had it in you.",
                    "Hold on a second! [NEMESIS] just interrupted [TARGET]'s [SPELL]. This must be what they call a 'rare occurrence'.",
                    "I can't believe my eyes. [NEMESIS] actually interrupted [TARGET]'s [SPELL]. Are you feeling alright?",
                    "Is this really happening? [NEMESIS] interrupted [TARGET]'s [SPELL]. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] interrupted [TARGET]'s [SPELL]. I guess even a broken clock is right twice a day.",
                    "Interesting development! [NEMESIS] just interrupted [TARGET]'s [SPELL]. A noteworthy event, indeed.",
                    "I must be seeing things. [NEMESIS] interrupted [TARGET]'s [SPELL]. Quick, someone check if pigs are flying!"
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "Oh look, I had to dispel that myself. [NEMESIS], were you too busy admiring the scenery?",
                    "Guess I'll handle the dispels since [NEMESIS] is too preoccupied with... whatever it is they're doing.",
                    "There goes another dispel from me. [NEMESIS], feel free to contribute anytime this dungeon.",
                    "I suppose I'll take care of the dispelling. We can't expect [NEMESIS] to do everything, can we?",
                    "Another dispel done by yours truly. [NEMESIS], this is what being useful looks like, just so you know.",
                    "Oh, was I supposed to leave that for you to dispel, [NEMESIS]? My bad, I forgot you were here.",
                    "Look at that, I'm dispelling again. [NEMESIS], don't worry about helping or anything.",
                    "Dispelling all by myself. [NEMESIS], your consistent lack of assistance is truly something.",
                    "I'll just handle all the dispels, shall I? [NEMESIS], please, continue to focus on... whatever it is you're doing.",
                    "Another one dispelled. [NEMESIS], feel free to pretend you were about to do it."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually dispelled something. I guess wonders never cease.",
                    "Oh, look at that. [NEMESIS] managed a dispel. Did you accidentally press the right button?",
                    "I'm pleasantly surprised. [NEMESIS] dispelled something. Maybe there's hope for you after all.",
                    "Wow, [NEMESIS] actually used dispel. I didn't think you knew how to do that.",
                    "Hold everything! [NEMESIS] just dispelled. This must be what they call a 'rare event'.",
                    "I can't believe my eyes. [NEMESIS] actually dispelled something. Are you feeling okay?",
                    "Is this really happening? [NEMESIS] used dispel. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] dispelled. I guess miracles do happen... occasionally.",
                    "Interesting turn of events! [NEMESIS] just used dispel. A moment to remember, indeed.",
                    "I must be dreaming. [NEMESIS] dispelled something. Someone pinch me, quick!"
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "Oh look, I had to CC that myself. [NEMESIS], were you too busy sightseeing to notice?",
                    "Guess I'll handle the CC since [NEMESIS] is too preoccupied with... whatever they're up to.",
                    "There goes another CC from me. [NEMESIS], feel free to join in the fight anytime.",
                    "I suppose I'll take care of the crowd control. We can't expect [NEMESIS] to do everything, can we?",
                    "Another mob CC'd by yours truly. [NEMESIS], this is what being helpful looks like, in case you were curious.",
                    "Oh, was I supposed to leave that for you to CC, [NEMESIS]? My bad, I forgot you were with us.",
                    "Look at that, I'm CCing again. [NEMESIS], don't strain yourself or anything.",
                    "Crowd controlling all by myself. [NEMESIS], your consistent lack of assistance is truly remarkable.",
                    "I'll just handle all the CC, shall I? [NEMESIS], please, continue to focus on... whatever it is you're doing.",
                    "Another one CC'd. [NEMESIS], feel free to pretend you were about to do it."
                },
                ["NEMESIS"] = {
                    "Well, well, [NEMESIS] actually CC'd something. I guess miracles do happen.",
                    "Oh, look at that. [NEMESIS] managed to CC. Did you accidentally use the right ability?",
                    "I'm pleasantly surprised. [NEMESIS] CC'd something. Maybe there's hope for you yet.",
                    "Wow, [NEMESIS] actually used CC. I didn't think you knew what those letters stood for.",
                    "Hold everything! [NEMESIS] just CC'd a mob. This must be what they call a 'once in a blue moon' event.",
                    "I can't believe my eyes. [NEMESIS] actually CC'd something. Did someone else take over your character?",
                    "Is this really happening? [NEMESIS] used CC. I thought I'd never see the day.",
                    "Well, I'll be. [NEMESIS] CC'd a mob. I guess even a blind squirrel finds a nut once in a while.",
                    "Interesting development! [NEMESIS] just used CC. A moment to remember, indeed.",
                    "I must be hallucinating. [NEMESIS] CC'd something. Someone pinch me, quick!"
                }
            }
        }
    },

    -- Index 4: Slightly negative, but more neutral
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Well, [NEMESIS], that didn't quite go as planned. Maybe we should review our strategy.",
                    "Hmm, [NEMESIS], I think we might need to adjust our approach. That wasn't our best attempt.",
                    "[NEMESIS], it seems like we're having some trouble with this fight. Any ideas on what we could improve?",
                    "That was a bit rough, [NEMESIS]. Let's regroup and figure out where we went wrong.",
                    "Well, [NEMESIS], I guess we found out what doesn't work. Progress, in a way?",
                    "That didn't go quite as expected, [NEMESIS]. Any thoughts on what we could do differently?",
                    "[NEMESIS], it looks like we might need to rethink our tactics. That attempt was... challenging.",
                    "Well, that was an experience, [NEMESIS]. Let's see if we can learn something from it.",
                    "I think we might have room for improvement, [NEMESIS]. Any suggestions for our next try?",
                    "[NEMESIS], that attempt was... interesting. Maybe we should discuss our approach before the next pull."
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Oops, looks like I took a bit of a tumble there. [NEMESIS], any thoughts on how we could prevent that next time?",
                    "Well, that was unfortunate. [NEMESIS], do you think we could adjust our positioning to avoid that?",
                    "[NEMESIS], I seem to have run into some trouble there. Any suggestions for the next attempt?",
                    "Hmm, that didn't go quite as planned. [NEMESIS], what do you think we could do differently?",
                    "Well, [NEMESIS], I guess I found out where not to stand. Let's work on our coordination for the next try.",
                    "That didn't end well for me. [NEMESIS], did you notice anything we could improve on?",
                    "I seem to have met an untimely end there. [NEMESIS], any ideas on how to avoid that in the future?",
                    "Well, that was a learning experience. [NEMESIS], what do you think went wrong there?",
                    "Looks like I made a mistake there. [NEMESIS], any thoughts on how we could handle that mechanic better?",
                    "That didn't go as I hoped. [NEMESIS], do you have any insights on what we could change for next time?"
                },
                ["NEMESIS"] = {
                    "Oh, [NEMESIS] is down. That's going to make things a bit more challenging.",
                    "Looks like [NEMESIS] had a bit of bad luck there. We'll need to adjust our strategy.",
                    "Well, we've lost [NEMESIS]. Let's see if we can recover from this setback.",
                    "[NEMESIS] has fallen. This might complicate things a bit.",
                    "It seems [NEMESIS] is taking an unscheduled break. We'll have to work around this.",
                    "[NEMESIS] is down. That's not ideal, but let's see how we can adapt.",
                    "We've lost [NEMESIS]. This changes our approach a bit. Any ideas?",
                    "Looks like [NEMESIS] is out of commission. We'll need to rethink our strategy.",
                    "[NEMESIS] has fallen. This is a setback, but we can still turn this around.",
                    "Well, [NEMESIS] is down. Let's focus on how we can compensate for this loss."
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] is down. [NEMESIS], we might need to adjust our strategy a bit.",
                    "We've lost [BYSTANDER]. [NEMESIS], any thoughts on how we should adapt?",
                    "Looks like [BYSTANDER] is out. [NEMESIS], this might change our approach a little.",
                    "[BYSTANDER] has fallen. [NEMESIS], we'll need to be extra careful now.",
                    "Well, [BYSTANDER] is down. [NEMESIS], let's think about how we can compensate.",
                    "[BYSTANDER] is no longer with us. [NEMESIS], we might need to rethink our roles here.",
                    "We're down one with [BYSTANDER] out. [NEMESIS], any ideas on how to proceed?",
                    "[BYSTANDER] has met an unfortunate end. [NEMESIS], we'll need to adapt our strategy.",
                    "Looks like we've lost [BYSTANDER]. [NEMESIS], this might require some quick thinking.",
                    "[BYSTANDER] is down for the count. [NEMESIS], we'll need to be extra vigilant now."
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, [NEMESIS], let's see if we can improve on our last attempt.",
                    "Here we go again. [NEMESIS], remember what we discussed about the mechanics.",
                    "Boss time, everyone. [NEMESIS], let's focus on executing our strategy this time.",
                    "Let's do this. [NEMESIS], keep an eye out for those key mechanics we talked about.",
                    "[NEMESIS], remember to communicate if you're having trouble with any part of the fight.",
                    "Okay, [NEMESIS], let's try to avoid the mistakes from last time. We've got this.",
                    "Boss incoming. [NEMESIS], stay alert and stick to the plan we discussed.",
                    "Here we go. [NEMESIS], let's see if we can make some progress this attempt.",
                    "It's time to face the boss. [NEMESIS], remember your role and we should be fine.",
                    "[NEMESIS], ready for another try? Let's see if we can do better this time."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Well done, everyone. [NEMESIS], you seemed more comfortable with the mechanics that time.",
                    "We did it! [NEMESIS], I noticed some improvement in your performance there.",
                    "Victory at last! [NEMESIS], your efforts to improve definitely showed in that attempt.",
                    "Great job, team. [NEMESIS], you handled your role much better this time.",
                    "Success! [NEMESIS], I saw you adapting to the fight mechanics better there.",
                    "We've done it! [NEMESIS], your contribution was notably better this time around.",
                    "Excellent work, everyone. [NEMESIS], you seemed more in sync with the group that time.",
                    "That's how it's done! [NEMESIS], I could see you were more focused on your tasks.",
                    "We've conquered the boss! [NEMESIS], your improvement was evident in that attempt.",
                    "Victory is ours! [NEMESIS], you definitely stepped up your game for that one."
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Oh, [NEMESIS] has joined. Let's see how this goes.",
                    "Well, [NEMESIS] is here. This could be interesting.",
                    "[NEMESIS] has joined the group. Let's hope for a smooth run.",
                    "Looks like [NEMESIS] is with us. We'll see how this plays out.",
                    "[NEMESIS] is here. This might change our group dynamic a bit.",
                    "[NEMESIS] has joined. Let's try to work together effectively.",
                    "We have [NEMESIS] with us now. This could affect our strategy.",
                    "[NEMESIS] is part of the team. Let's see how we can incorporate their skills.",
                    "Alright, [NEMESIS] is here. We'll need to adjust our approach accordingly.",
                    "[NEMESIS] has joined us. This might require some adaptability on our part."
                },
                ["SELF"] = {
                    "Hello, [NEMESIS]. Let's see if we can work well together this time.",
                    "Ah, [NEMESIS] is here. I hope we can coordinate effectively.",
                    "Well, [NEMESIS], we meet again. Let's try to make the best of it.",
                    "[NEMESIS], I see you've joined. Let's aim for a productive run.",
                    "Oh, it's [NEMESIS]. Well, let's see how this goes.",
                    "Hello again, [NEMESIS]. Here's hoping for a smooth collaboration.",
                    "[NEMESIS], you're with us this time. Let's try to work as a team.",
                    "I see [NEMESIS] has joined. We'll need to communicate clearly to succeed.",
                    "Well, [NEMESIS] is here. Let's attempt to synergize our efforts.",
                    "Greetings, [NEMESIS]. Let's see if we can find a good rhythm this time."
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]. Just so you know, [NEMESIS] is part of our group.",
                    "Hey [BYSTANDER], glad you could join. We have [NEMESIS] with us as well.",
                    "[BYSTANDER], welcome to the team. [NEMESIS] is also here, just FYI.",
                    "Good to have you, [BYSTANDER]. [NEMESIS] is part of our group too.",
                    "Welcome aboard, [BYSTANDER]. Just a heads up, [NEMESIS] is with us.",
                    "[BYSTANDER], thanks for joining. We've got [NEMESIS] in the group as well.",
                    "Glad you're here, [BYSTANDER]. [NEMESIS] is also part of our team.",
                    "Hey [BYSTANDER], welcome. Just letting you know, [NEMESIS] is here too.",
                    "[BYSTANDER], welcome to the group. We're also running with [NEMESIS].",
                    "Good to see you, [BYSTANDER]. Just to let you know, [NEMESIS] is part of our group as well."
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "Looks like [NEMESIS] has left the group. We'll need to adjust our strategy.",
                    "[NEMESIS] has departed. This might change our approach a bit.",
                    "Well, [NEMESIS] is gone. Let's see how we can adapt to this change.",
                    "[NEMESIS] has left us. We may need to rethink our roles.",
                    "It seems [NEMESIS] has moved on. We'll have to compensate for their absence.",
                    "[NEMESIS] is no longer with us. This could affect our group dynamic.",
                    "We've lost [NEMESIS]. Let's consider how this impacts our plan.",
                    "[NEMESIS] has exited the group. We might need to reevaluate our strategy.",
                    "Well, [NEMESIS] has left. We'll need to adjust to fill their role.",
                    "[NEMESIS] is out. Let's think about how we can cover their responsibilities."
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has left the group. [NEMESIS], we might need to adjust our approach.",
                    "Looks like we've lost [BYSTANDER]. [NEMESIS], any thoughts on how we should adapt?",
                    "Well, [BYSTANDER] is gone. [NEMESIS], this might change our strategy a bit.",
                    "[BYSTANDER] has departed. [NEMESIS], we may need to rethink our roles.",
                    "It seems [BYSTANDER] has moved on. [NEMESIS], we'll have to compensate for their absence.",
                    "[BYSTANDER] is no longer with us. [NEMESIS], this could affect our group dynamic.",
                    "We've lost [BYSTANDER]. [NEMESIS], let's consider how this impacts our plan.",
                    "[BYSTANDER] has exited the group. [NEMESIS], we might need to reevaluate our strategy.",
                    "Well, [BYSTANDER] has left. [NEMESIS], we'll need to adjust to fill their role.",
                    "[BYSTANDER] is out. [NEMESIS], let's think about how we can cover their responsibilities."
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], remember to focus on the key mechanics.",
                    "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], let's try to work together effectively.",
                    "[KEYSTONELEVEL] time. [NEMESIS], keep in mind the strategies we discussed.",
                    "Let's do this [KEYSTONELEVEL]. [NEMESIS], stay alert and communicate if you need help.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], remember that teamwork is crucial.",
                    "We're beginning the [KEYSTONELEVEL]. [NEMESIS], let's aim for a smooth run.",
                    "[KEYSTONELEVEL] incoming. [NEMESIS], try to stay focused on your role.",
                    "Here we go with the [KEYSTONELEVEL]. [NEMESIS], let's see if we can improve on our last attempt.",
                    "It's [KEYSTONELEVEL] time. [NEMESIS], remember to pace yourself and avoid unnecessary risks.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], keep in mind our overall strategy."
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "Well, that [KEYSTONELEVEL] didn't go as planned. [NEMESIS], any thoughts on what we could improve?",
                    "We didn't quite make it through that [KEYSTONELEVEL]. [NEMESIS], what do you think went wrong?",
                    "That [KEYSTONELEVEL] was a bit rough. [NEMESIS], did you notice any particular issues?",
                    "We fell short on that [KEYSTONELEVEL]. [NEMESIS], any ideas on how we could do better next time?",
                    "[NEMESIS], that [KEYSTONELEVEL] was challenging. What do you think we should focus on improving?",
                    "We didn't complete the [KEYSTONELEVEL] in time. [NEMESIS], where do you think we lost the most time?",
                    "That [KEYSTONELEVEL] didn't work out. [NEMESIS], what part did you find most difficult?",
                    "We missed the timer on that [KEYSTONELEVEL]. [NEMESIS], any suggestions for our next attempt?",
                    "That [KEYSTONELEVEL] was a learning experience. [NEMESIS], what do you think we could have done differently?",
                    "[NEMESIS], we didn't quite make it through that [KEYSTONELEVEL]. What areas do you think we need to work on?"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "We did it! Great job on timing that [KEYSTONELEVEL]. [NEMESIS], you handled your role well.",
                    "Excellent work, everyone. We timed the [KEYSTONELEVEL]. [NEMESIS], I noticed some good plays from you.",
                    "Success! We completed the [KEYSTONELEVEL] in time. [NEMESIS], your contribution was valuable.",
                    "We've done it! [KEYSTONELEVEL] timed. [NEMESIS], you seemed more comfortable with the mechanics this run.",
                    "Congratulations on timing the [KEYSTONELEVEL]! [NEMESIS], your performance has improved.",
                    "We've successfully timed the [KEYSTONELEVEL]. [NEMESIS], I saw some good decision-making from you.",
                    "Great job on the [KEYSTONELEVEL], team! [NEMESIS], you worked well with the group this time.",
                    "We've timed the [KEYSTONELEVEL]! [NEMESIS], your efforts definitely contributed to our success.",
                    "Excellent run! We've completed the [KEYSTONELEVEL] in time. [NEMESIS], you handled your responsibilities well.",
                    "[KEYSTONELEVEL] timed successfully! [NEMESIS], I appreciated your focus during that run."
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "I've interrupted [TARGET]'s [SPELL]. [NEMESIS], keep an eye out for more casts we need to stop.",
                    "Just stopped [TARGET]'s [SPELL]. [NEMESIS], let's try to coordinate our interrupts better.",
                    "I caught [TARGET]'s [SPELL]. [NEMESIS], can you take the next one?",
                    "[TARGET]'s [SPELL] interrupted. [NEMESIS], remember we need to keep these abilities in check.",
                    "Got that interrupt on [TARGET]'s [SPELL]. [NEMESIS], stay alert for more castings.",
                    "I've handled [TARGET]'s [SPELL]. [NEMESIS], let's work on our interrupt rotation.",
                    "Managed to stop [TARGET]'s [SPELL]. [NEMESIS], keep track of when your interrupt is available.",
                    "[TARGET]'s [SPELL] has been interrupted. [NEMESIS], we need to stay on top of these casts.",
                    "I've taken care of [TARGET]'s [SPELL]. [NEMESIS], be ready for the next one.",
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], let's try to improve our interrupt coordination."
                },
                ["NEMESIS"] = {
                    "Good interrupt on [TARGET]'s [SPELL], [NEMESIS]. Keep it up.",
                    "Nice catch on [TARGET]'s [SPELL], [NEMESIS]. Stay alert for more.",
                    "Well done interrupting [TARGET]'s [SPELL], [NEMESIS]. That was important.",
                    "[NEMESIS], good job stopping [TARGET]'s [SPELL]. Let's keep this coordination going.",
                    "Thanks for catching [TARGET]'s [SPELL], [NEMESIS]. That helps a lot.",
                    "Solid interrupt on [TARGET]'s [SPELL], [NEMESIS]. Keep an eye out for more casts.",
                    "[NEMESIS], nice work on interrupting [TARGET]'s [SPELL]. That makes our job easier.",
                    "Good awareness on [TARGET]'s [SPELL], [NEMESIS]. Let's keep up the good work.",
                    "Thanks for handling [TARGET]'s [SPELL], [NEMESIS]. That's good teamwork.",
                    "[NEMESIS], well done on that interrupt of [TARGET]'s [SPELL]. Stay vigilant for more."
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "I've dispelled that effect. [NEMESIS], keep an eye out for more we need to remove.",
                    "Just removed a harmful spell. [NEMESIS], let's try to coordinate our dispels better.",
                    "I took care of that dispel. [NEMESIS], can you handle the next one?",
                    "Harmful effect dispelled. [NEMESIS], remember we need to keep on top of these.",
                    "Got that dispel. [NEMESIS], stay alert for more effects we need to remove.",
                    "I've handled that dispel. [NEMESIS], let's work on our dispel priorities.",
                    "Managed to remove that effect. [NEMESIS], keep track of when your dispel is available.",
                    "That harmful spell has been dispelled. [NEMESIS], we need to stay vigilant.",
                    "I've taken care of that dispel. [NEMESIS], be ready for the next one.",
                    "Effect removed. [NEMESIS], let's try to improve our dispel coordination."
                },
                ["NEMESIS"] = {
                    "Good dispel, [NEMESIS]. Keep it up.",
                    "Nice removal of that effect, [NEMESIS]. Stay alert for more.",
                    "Well done on that dispel, [NEMESIS]. That was important.",
                    "[NEMESIS], good job removing that harmful spell. Let's keep this coordination going.",
                    "Thanks for that dispel, [NEMESIS]. That helps a lot.",
                    "Solid dispel work, [NEMESIS]. Keep an eye out for more effects we need to remove.",
                    "[NEMESIS], nice work on that dispel. That makes our job easier.",
                    "Good awareness on that harmful effect, [NEMESIS]. Let's keep up the good work.",
                    "Thanks for handling that dispel, [NEMESIS]. That's good teamwork.",
                    "[NEMESIS], well done on that dispel. Stay vigilant for more."
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "I've CC'd that target. [NEMESIS], keep an eye out for more we need to control.",
                    "Just applied some crowd control. [NEMESIS], let's try to coordinate our CC better.",
                    "I took care of that CC. [NEMESIS], can you handle the next one?",
                    "Target controlled. [NEMESIS], remember we need to keep on top of crowd control.",
                    "Got that CC. [NEMESIS], stay alert for more targets we need to control.",
                    "I've handled that crowd control. [NEMESIS], let's work on our CC priorities.",
                    "Managed to control that target. [NEMESIS], keep track of when your CC is available.",
                    "That mob has been CC'd. [NEMESIS], we need to stay vigilant with our crowd control.",
                    "I've taken care of that CC. [NEMESIS], be ready for the next one.",
                    "Crowd control applied. [NEMESIS], let's try to improve our CC coordination."
                },
                ["NEMESIS"] = {
                    "Good CC, [NEMESIS]. Keep it up.",
                    "Nice control of that target, [NEMESIS]. Stay alert for more.",
                    "Well done on that crowd control, [NEMESIS]. That was important.",
                    "[NEMESIS], good job controlling that mob. Let's keep this coordination going.",
                    "Thanks for that CC, [NEMESIS]. That helps a lot.",
                    "Solid crowd control work, [NEMESIS]. Keep an eye out for more targets we need to manage.",
                    "[NEMESIS], nice work on that CC. That makes our job easier.",
                    "Good awareness on that crowd control, [NEMESIS]. Let's keep up the good work.",
                    "Thanks for handling that CC, [NEMESIS]. That's good teamwork.",
                    "[NEMESIS], well done on that crowd control. Stay vigilant for more opportunities."
                }
            }
        }
    },

    -- Index 5: Neutral
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Well, that was an attempt. [NEMESIS], what are your thoughts on our performance?",
                    "[NEMESIS], it looks like we're still figuring this out. Any observations from that try?",
                    "Okay, not quite there yet. [NEMESIS], what do you think we should focus on next time?",
                    "That was... interesting. [NEMESIS], did you notice anything we could improve on?",
                    "Well, we gave it a shot. [NEMESIS], any ideas for our next attempt?",
                    "That didn't go as planned. [NEMESIS], what do you think we could do differently?",
                    "We're making progress, even if it doesn't feel like it. [NEMESIS], any thoughts?",
                    "That was a learning experience. [NEMESIS], what stood out to you during that attempt?",
                    "We're getting there. [NEMESIS], what part do you think we need to work on most?",
                    "Not quite a success, but not a total loss either. [NEMESIS], what's your take on that try?"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Whoops, I'm down. [NEMESIS], did you see what happened there?",
                    "Well, that's me out. [NEMESIS], any thoughts on how we could prevent that next time?",
                    "[NEMESIS], I seem to have run into some trouble. Did you notice anything I could do differently?",
                    "Looks like I made a mistake there. [NEMESIS], any suggestions for the next try?",
                    "Well, that didn't go as planned. [NEMESIS], what's your take on the situation?",
                    "I seem to have met my demise. [NEMESIS], any insights on what went wrong?",
                    "That didn't end well for me. [NEMESIS], did you spot where I went wrong?",
                    "I've fallen and can't get up. [NEMESIS], any ideas on how to avoid that next time?",
                    "Well, I'm out of the fight. [NEMESIS], what do you think led to that?",
                    "Looks like I'm taking a dirt nap. [NEMESIS], any thoughts on how to prevent that in future attempts?"
                },
                ["NEMESIS"] = {
                    "[NEMESIS] is down. How should we adapt our strategy?",
                    "We've lost [NEMESIS]. Let's consider how to proceed from here.",
                    "[NEMESIS] has fallen. What adjustments should we make?",
                    "It looks like [NEMESIS] is out. How do we compensate for this?",
                    "[NEMESIS] is no longer with us. What's our next move?",
                    "We're down one with [NEMESIS] out. How should we adjust?",
                    "[NEMESIS] has been defeated. What's our plan moving forward?",
                    "It seems [NEMESIS] is down for the count. How do we adapt?",
                    "We've lost [NEMESIS]. How does this change our approach?",
                    "[NEMESIS] is out of the fight. What's our new game plan?"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] is down. [NEMESIS], how should we adjust our strategy?",
                    "We've lost [BYSTANDER]. [NEMESIS], any thoughts on how to proceed?",
                    "[BYSTANDER] has fallen. [NEMESIS], what adjustments do you think we should make?",
                    "It looks like [BYSTANDER] is out. [NEMESIS], how do you suggest we compensate for this?",
                    "[BYSTANDER] is no longer with us. [NEMESIS], what's your take on our next move?",
                    "We're down one with [BYSTANDER] out. [NEMESIS], how should we adapt?",
                    "[BYSTANDER] has been defeated. [NEMESIS], what's your view on our plan moving forward?",
                    "It seems [BYSTANDER] is down for the count. [NEMESIS], how do you think we should adjust?",
                    "We've lost [BYSTANDER]. [NEMESIS], how do you think this changes our approach?",
                    "[BYSTANDER] is out of the fight. [NEMESIS], what's your opinion on our new game plan?"
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, let's give this another shot. [NEMESIS], ready to go?",
                    "Here we go again. [NEMESIS], remember what we discussed about the mechanics.",
                    "Boss time, everyone. [NEMESIS], let's focus on executing our strategy.",
                    "Let's do this. [NEMESIS], keep an eye out for those key mechanics we talked about.",
                    "[NEMESIS], remember to communicate if you're having trouble with any part of the fight.",
                    "Okay, [NEMESIS], let's see if we can improve on our last attempt.",
                    "Boss incoming. [NEMESIS], stay alert and stick to the plan.",
                    "Here we go. [NEMESIS], let's see if we can make some progress this time.",
                    "It's time to face the boss. [NEMESIS], remember your role and we should be fine.",
                    "[NEMESIS], ready for another try? Let's see what we can accomplish this time."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Great job, everyone! [NEMESIS], nice work on handling your part.",
                    "We did it! [NEMESIS], I noticed some good plays from you there.",
                    "Excellent teamwork! [NEMESIS], you seemed more comfortable with the mechanics that time.",
                    "Victory! [NEMESIS], your performance definitely contributed to our success.",
                    "Well done, team! [NEMESIS], I saw some improvement in your gameplay.",
                    "That's how it's done! [NEMESIS], you handled your role well.",
                    "Congratulations, everyone! [NEMESIS], you were on point with your responsibilities.",
                    "Success! [NEMESIS], your efforts definitely paid off in that fight.",
                    "We nailed it! [NEMESIS], you seemed much more in sync with the group this time.",
                    "Fantastic work! [NEMESIS], your contribution was valuable to our victory."
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Welcome to the group, [NEMESIS].",
                    "[NEMESIS] has joined us. Hello there.",
                    "Greetings, [NEMESIS]. Glad you could join us.",
                    "Hey [NEMESIS], welcome to the team.",
                    "[NEMESIS] is here. Welcome aboard.",
                    "Good to have you with us, [NEMESIS].",
                    "Welcome, [NEMESIS]. Hope you're ready for some action.",
                    "[NEMESIS] has joined the party. Hello!",
                    "Hey everyone, [NEMESIS] is joining us.",
                    "Welcome to the group, [NEMESIS]. Let's get started."
                },
                ["SELF"] = {
                    "Hello, [NEMESIS]. Let's work together effectively.",
                    "Ah, [NEMESIS], we meet again. Here's to a good run.",
                    "Greetings, [NEMESIS]. Looking forward to working with you.",
                    "[NEMESIS], good to see you. Let's have a productive session.",
                    "Hello there, [NEMESIS]. Ready for some teamwork?",
                    "Nice to see you, [NEMESIS]. Let's make this a good run.",
                    "[NEMESIS], hello. Here's hoping for smooth cooperation.",
                    "Greetings, [NEMESIS]. Let's aim for success together.",
                    "Hey [NEMESIS], looking forward to a good session.",
                    "Hello, [NEMESIS]. Let's see what we can accomplish as a team."
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]. [NEMESIS] is also part of our group.",
                    "Hey [BYSTANDER], glad you could join. We have [NEMESIS] with us as well.",
                    "[BYSTANDER], welcome to the team. [NEMESIS] is here too.",
                    "Good to have you, [BYSTANDER]. [NEMESIS] is part of our group as well.",
                    "Welcome aboard, [BYSTANDER]. Just to let you know, [NEMESIS] is with us.",
                    "[BYSTANDER], thanks for joining. [NEMESIS] is in the group too.",
                    "Glad you're here, [BYSTANDER]. We've got [NEMESIS] in the team as well.",
                    "Hey [BYSTANDER], welcome. [NEMESIS] is also part of our group.",
                    "[BYSTANDER], welcome to the group. We're also running with [NEMESIS].",
                    "Good to see you, [BYSTANDER]. Just so you know, [NEMESIS] is part of our team too."
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "[NEMESIS] has left the group. Take care!",
                    "Looks like [NEMESIS] is heading out. Farewell!",
                    "[NEMESIS] has departed. Safe travels!",
                    "And [NEMESIS] is off. All the best!",
                    "[NEMESIS] has left us. Until next time!",
                    "Seems [NEMESIS] is moving on. Take it easy!",
                    "[NEMESIS] has exited the group. Goodbye!",
                    "Looks like [NEMESIS] is done for now. See you around!",
                    "[NEMESIS] has left the party. Safe journeys!",
                    "And there goes [NEMESIS]. Till we meet again!"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has left the group. [NEMESIS], looks like we'll need to adjust our strategy.",
                    "Seems [BYSTANDER] is heading out. [NEMESIS], any thoughts on how we should proceed?",
                    "[BYSTANDER] has departed. [NEMESIS], this might change our approach a bit.",
                    "And [BYSTANDER] is off. [NEMESIS], we may need to rethink our roles.",
                    "[BYSTANDER] has left us. [NEMESIS], how do you think we should compensate?",
                    "Looks like [BYSTANDER] is done for now. [NEMESIS], any ideas on adapting our plan?",
                    "[BYSTANDER] has exited the group. [NEMESIS], we might need to reevaluate our strategy.",
                    "[BYSTANDER] has left the party. [NEMESIS], how should we adjust to this change?",
                    "And there goes [BYSTANDER]. [NEMESIS], what's your take on our next move?",
                    "[BYSTANDER] has moved on. [NEMESIS], how do you think we should reorganize?"
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], ready to go?",
                    "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], let's work together on this one.",
                    "[KEYSTONELEVEL] time. [NEMESIS], remember to focus on the key mechanics.",
                    "Let's do this [KEYSTONELEVEL]. [NEMESIS], keep an eye out for important abilities.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], remember that communication is key.",
                    "We're beginning the [KEYSTONELEVEL]. [NEMESIS], let's aim for a smooth run.",
                    "[KEYSTONELEVEL] incoming. [NEMESIS], stay focused and we'll do fine.",
                    "Here we go with the [KEYSTONELEVEL]. [NEMESIS], let's see what we can accomplish.",
                    "It's [KEYSTONELEVEL] time. [NEMESIS], remember to pace yourself.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], let's keep our overall strategy in mind."
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "Well, that [KEYSTONELEVEL] didn't go as planned. [NEMESIS], any thoughts on what we could improve?",
                    "We didn't quite make it through that [KEYSTONELEVEL]. [NEMESIS], what do you think went wrong?",
                    "That [KEYSTONELEVEL] was a bit rough. [NEMESIS], did you notice any particular issues?",
                    "We fell short on that [KEYSTONELEVEL]. [NEMESIS], any ideas on how we could do better next time?",
                    "[NEMESIS], that [KEYSTONELEVEL] was challenging. What do you think we should focus on improving?",
                    "We didn't complete the [KEYSTONELEVEL] in time. [NEMESIS], where do you think we lost the most time?",
                    "That [KEYSTONELEVEL] didn't work out. [NEMESIS], what part did you find most difficult?",
                    "We missed the timer on that [KEYSTONELEVEL]. [NEMESIS], any suggestions for our next attempt?",
                    "That [KEYSTONELEVEL] was a learning experience. [NEMESIS], what do you think we could have done differently?",
                    "[NEMESIS], we didn't quite make it through that [KEYSTONELEVEL]. What areas do you think we need to work on?"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Great job on timing that [KEYSTONELEVEL]! [NEMESIS], nice work.",
                    "We did it! [KEYSTONELEVEL] completed in time. Good job, [NEMESIS].",
                    "Excellent work on the [KEYSTONELEVEL], team. [NEMESIS], well played.",
                    "Success! [KEYSTONELEVEL] timed. [NEMESIS], you handled that well.",
                    "[KEYSTONELEVEL] completed within the timer. Nice contribution, [NEMESIS].",
                    "We've successfully timed the [KEYSTONELEVEL]. Good work, [NEMESIS].",
                    "That's a timed [KEYSTONELEVEL]! [NEMESIS], you did your part well.",
                    "Nicely done on timing the [KEYSTONELEVEL]. [NEMESIS], good job.",
                    "[KEYSTONELEVEL] completed successfully. [NEMESIS], you played your role well.",
                    "We've timed the [KEYSTONELEVEL]! [NEMESIS], thanks for your contribution."
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], can you take the next one?",
                    "I've stopped [TARGET]'s [SPELL]. [NEMESIS], keep an eye out for more casts.",
                    "Just interrupted [TARGET]'s [SPELL]. [NEMESIS], your interrupt up soon?",
                    "[TARGET]'s [SPELL] interrupted by me. [NEMESIS], let's coordinate our interrupts.",
                    "Got that interrupt on [TARGET]'s [SPELL]. [NEMESIS], you're up next.",
                    "I've handled [TARGET]'s [SPELL]. [NEMESIS], be ready for the next cast.",
                    "Managed to interrupt [TARGET]'s [SPELL]. [NEMESIS], watch for more.",
                    "[TARGET]'s [SPELL] stopped. [NEMESIS], let's keep this rotation going.",
                    "I've taken care of [TARGET]'s [SPELL]. [NEMESIS], your turn coming up.",
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], stay alert for the next one."
                },
                ["NEMESIS"] = {
                    "Good interrupt on [TARGET]'s [SPELL], [NEMESIS].",
                    "Nice catch on [TARGET]'s [SPELL], [NEMESIS].",
                    "Well done interrupting [TARGET]'s [SPELL], [NEMESIS].",
                    "[NEMESIS], good job stopping [TARGET]'s [SPELL].",
                    "Thanks for catching [TARGET]'s [SPELL], [NEMESIS].",
                    "Solid interrupt on [TARGET]'s [SPELL], [NEMESIS].",
                    "[NEMESIS], nice work on interrupting [TARGET]'s [SPELL].",
                    "Good awareness on [TARGET]'s [SPELL], [NEMESIS].",
                    "Thanks for handling [TARGET]'s [SPELL], [NEMESIS].",
                    "[NEMESIS], well done on that interrupt of [TARGET]'s [SPELL]."
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "Dispelled that effect. [NEMESIS], watch for more we need to remove.",
                    "I've removed that spell. [NEMESIS], your dispel ready?",
                    "Just dispelled that. [NEMESIS], keep an eye out for more effects.",
                    "Harmful effect removed by me. [NEMESIS], let's coordinate our dispels.",
                    "Got that dispel. [NEMESIS], you're up next if needed.",
                    "I've handled that dispel. [NEMESIS], be ready for the next one.",
                    "Managed to dispel that effect. [NEMESIS], watch for more.",
                    "That harmful spell has been removed. [NEMESIS], let's keep this up.",
                    "I've taken care of that dispel. [NEMESIS], your turn coming up.",
                    "Effect dispelled. [NEMESIS], stay alert for the next one."
                },
                ["NEMESIS"] = {
                    "Good dispel, [NEMESIS].",
                    "Nice removal of that effect, [NEMESIS].",
                    "Well done on that dispel, [NEMESIS].",
                    "[NEMESIS], good job removing that harmful spell.",
                    "Thanks for that dispel, [NEMESIS].",
                    "Solid dispel work, [NEMESIS].",
                    "[NEMESIS], nice work on that dispel.",
                    "Good awareness on that harmful effect, [NEMESIS].",
                    "Thanks for handling that dispel, [NEMESIS].",
                    "[NEMESIS], well done on that dispel."
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "CC'd that target. [NEMESIS], watch for more we need to control.",
                    "I've applied crowd control. [NEMESIS], your CC ready?",
                    "Just CC'd that enemy. [NEMESIS], keep an eye out for more targets.",
                    "Crowd control applied by me. [NEMESIS], let's coordinate our CC.",
                    "Got that CC. [NEMESIS], you're up next if needed.",
                    "I've handled that crowd control. [NEMESIS], be ready for the next one.",
                    "Managed to CC that target. [NEMESIS], watch for more.",
                    "That mob has been controlled. [NEMESIS], let's keep this up.",
                    "I've taken care of that CC. [NEMESIS], your turn coming up.",
                    "Crowd control applied. [NEMESIS], stay alert for the next target."
                },
                ["NEMESIS"] = {
                    "Good CC, [NEMESIS].",
                    "Nice control of that target, [NEMESIS].",
                    "Well done on that crowd control, [NEMESIS].",
                    "[NEMESIS], good job controlling that mob.",
                    "Thanks for that CC, [NEMESIS].",
                    "Solid crowd control work, [NEMESIS].",
                    "[NEMESIS], nice work on that CC.",
                    "Good awareness on that crowd control, [NEMESIS].",
                    "Thanks for handling that CC, [NEMESIS].",
                    "[NEMESIS], well done on that crowd control."
                }
            }
        }
    },

    -- Index 6: Slightly positive, but still neutral
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "That was a good effort, [NEMESIS]. We're making progress, even if it doesn't feel like it.",
                    "[NEMESIS], I think we're getting closer. What positives did you see in that attempt?",
                    "We're learning with each try, [NEMESIS]. What do you think we did better this time?",
                    "Not quite there yet, but I see improvement, [NEMESIS]. What are your thoughts?",
                    "We're on the right track, [NEMESIS]. Any ideas on what to focus on next?",
                    "That attempt was better, [NEMESIS]. What part do you think went well?",
                    "We're making strides, [NEMESIS]. What aspect of the fight are you feeling more confident about?",
                    "I saw some good moments there, [NEMESIS]. What do you think was our strongest point?",
                    "We're getting closer, [NEMESIS]. What part of our strategy do you think is working best?",
                    "That was a solid try, [NEMESIS]. What do you think we should build on for the next attempt?"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Oops, my mistake there. [NEMESIS], did you notice anything that could help me avoid that next time?",
                    "Well, I zigged when I should have zagged. [NEMESIS], any advice for my next attempt?",
                    "[NEMESIS], I seem to have miscalculated there. Did you spot where I went wrong?",
                    "I'll do better next time. [NEMESIS], any suggestions on how I can improve?",
                    "Learning experience for me there. [NEMESIS], what would you recommend I do differently?",
                    "My bad on that one. [NEMESIS], did you see any warning signs I might have missed?",
                    "I'll need to adjust my approach there. [NEMESIS], any tips based on what you observed?",
                    "That didn't go as planned for me. [NEMESIS], what would you suggest I watch out for next time?",
                    "I'll aim to avoid that in the future. [NEMESIS], any insights on how I could position better?",
                    "Room for improvement on my part there. [NEMESIS], what do you think I should focus on?"
                },
                ["NEMESIS"] = {
                    "[NEMESIS] is down, but they put up a good fight. How can we build on their efforts?",
                    "We've lost [NEMESIS], but their contribution was valuable. How do we move forward from here?",
                    "[NEMESIS] has fallen, but they helped us learn. What can we take from their performance?",
                    "It looks like [NEMESIS] is out, but they gave it their all. How do we adapt our strategy?",
                    "[NEMESIS] is no longer with us, but their efforts weren't in vain. What's our next step?",
                    "[NEMESIS] is down, but they showed some good moves. How can we incorporate what worked?",
                    "We've lost [NEMESIS], but they had some strong moments. What can we learn from their approach?",
                    "[NEMESIS] has fallen, but not before making some progress. How do we build on that?",
                    "It seems [NEMESIS] is out, but they contributed well. How should we adjust our tactics?",
                    "[NEMESIS] is down, but they helped us understand the fight better. What's our plan moving forward?"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] is down. [NEMESIS], what positive aspects of their performance can we build on?",
                    "We've lost [BYSTANDER]. [NEMESIS], how can we adapt our strategy to cover their role?",
                    "[BYSTANDER] has fallen. [NEMESIS], what did they do well that we should try to continue?",
                    "It looks like [BYSTANDER] is out. [NEMESIS], how can we adjust to maintain our momentum?",
                    "[BYSTANDER] is no longer with us. [NEMESIS], what's your take on how we should proceed?",
                    "[BYSTANDER] is down. [NEMESIS], did you notice anything in their approach we could use?",
                    "We've lost [BYSTANDER]. [NEMESIS], how do you think we can compensate for their absence?",
                    "[BYSTANDER] has fallen. [NEMESIS], what aspects of their strategy should we try to maintain?",
                    "It seems [BYSTANDER] is out. [NEMESIS], how do you suggest we redistribute responsibilities?",
                    "[BYSTANDER] is down. [NEMESIS], what part of their role do you think is most critical for us to cover?"
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, let's give this another go. [NEMESIS], I believe we can do better this time.",
                    "Here we go again. [NEMESIS], let's apply what we've learned so far.",
                    "Boss time, everyone. [NEMESIS], I'm confident in our ability to improve.",
                    "Let's do this. [NEMESIS], remember the progress we've made and let's build on it.",
                    "[NEMESIS], we're getting better with each try. Let's see what we can accomplish this time.",
                    "Okay, [NEMESIS], I think we're close to cracking this. Ready to give it another shot?",
                    "Boss incoming. [NEMESIS], let's focus on executing our strategy even better this time.",
                    "Here we go. [NEMESIS], I have a good feeling about this attempt.",
                    "It's time to face the boss. [NEMESIS], let's show what we've learned from our previous tries.",
                    "[NEMESIS], ready for another round? I think we're on the verge of a breakthrough here."
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Excellent work, everyone! [NEMESIS], your performance really stood out this time.",
                    "We did it! [NEMESIS], I saw some great improvements in your gameplay.",
                    "Victory at last! [NEMESIS], your efforts really paid off in that fight.",
                    "Great job, team. [NEMESIS], you handled your role exceptionally well.",
                    "Success! [NEMESIS], I noticed you adapting really well to the fight mechanics.",
                    "We've done it! [NEMESIS], your contribution was key to our victory.",
                    "Fantastic work, everyone. [NEMESIS], you were really in sync with the group that time.",
                    "That's how it's done! [NEMESIS], I could see your focus and it made a difference.",
                    "We've conquered the boss! [NEMESIS], your improvement was clear in that attempt.",
                    "Victory is ours! [NEMESIS], you really stepped up your game for that one. Well done!"
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Welcome to the group, [NEMESIS]! Looking forward to working with you.",
                    "[NEMESIS] has joined us. Great to have you on board!",
                    "Greetings, [NEMESIS]! Glad you could join us for this run.",
                    "Hey [NEMESIS], welcome to the team! Your skills will be a great addition.",
                    "[NEMESIS] is here. Welcome! I think you'll fit in well with our group.",
                    "Good to have you with us, [NEMESIS]! Ready for some adventure?",
                    "Welcome, [NEMESIS]! I have a feeling you'll be a valuable asset to our team.",
                    "[NEMESIS] has joined the party. Excellent! Let's see what we can accomplish together.",
                    "Hey everyone, [NEMESIS] is joining us. I think this is going to be a great run!",
                    "Welcome to the group, [NEMESIS]. With you here, I think we've got a solid team composition."
                },
                ["SELF"] = {
                    "Hello, [NEMESIS]! I'm looking forward to working together effectively.",
                    "Ah, [NEMESIS], good to see you again. I think we'll make a great team.",
                    "Greetings, [NEMESIS]. I'm excited about the potential of our group.",
                    "[NEMESIS], it's good to be in a group with you. Let's aim for a productive run.",
                    "Hello there, [NEMESIS]. I have a good feeling about our team's synergy.",
                    "Nice to see you, [NEMESIS]. I think we have a strong group here.",
                    "[NEMESIS], hello! I'm optimistic about what we can achieve together.",
                    "Greetings, [NEMESIS]. I'm looking forward to seeing how our skills complement each other.",
                    "Hey [NEMESIS], glad to be grouped with you. I think we'll work well together.",
                    "Hello, [NEMESIS]. I'm excited to see what we can accomplish as a team."
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]! Just to let you know, [NEMESIS] is also part of our group. I think we have a strong team.",
                    "Hey [BYSTANDER], glad you could join. We have [NEMESIS] with us as well. This should be a good run!",
                    "[BYSTANDER], welcome to the team. [NEMESIS] is here too. I'm looking forward to seeing how we all work together.",
                    "Good to have you, [BYSTANDER]. [NEMESIS] is part of our group as well. I think we've got a solid composition.",
                    "Welcome aboard, [BYSTANDER]. Just to let you know, [NEMESIS] is with us. I have a good feeling about our group.",
                    "[BYSTANDER], thanks for joining. [NEMESIS] is in the group too. I think we've got all the bases covered.",
                    "Glad you're here, [BYSTANDER]. We've got [NEMESIS] in the team as well. This should be an interesting run!",
                    "Hey [BYSTANDER], welcome. [NEMESIS] is also part of our group. I'm excited to see how our skills complement each other.",
                    "[BYSTANDER], welcome to the group. We're also running with [NEMESIS]. I think we have a well-rounded team.",
                    "Good to see you, [BYSTANDER]. Just so you know, [NEMESIS] is part of our team too. I'm optimistic about what we can achieve together."
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "[NEMESIS] has left the group. Thanks for your contributions, and take care!",
                    "Looks like [NEMESIS] is heading out. It was great having you with us!",
                    "[NEMESIS] has departed. Thanks for being part of the team, safe travels!",
                    "And [NEMESIS] is off. We appreciate your efforts, all the best!",
                    "[NEMESIS] has left us. Thanks for your help, until next time!",
                    "Seems [NEMESIS] is moving on. It was a pleasure grouping with you!",
                    "[NEMESIS] has exited the group. Thanks for your contributions, take care!",
                    "Looks like [NEMESIS] is done for now. It was great having you along, see you around!",
                    "[NEMESIS] has left the party. Thanks for your help, safe journeys!",
                    "And there goes [NEMESIS]. We appreciate your time with us, till we meet again!"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has left the group. [NEMESIS], looks like we'll need to adjust our strategy, but I think we can manage.",
                    "Seems [BYSTANDER] is heading out. [NEMESIS], any thoughts on how we should proceed? I'm sure we can adapt.",
                    "[BYSTANDER] has departed. [NEMESIS], this might change our approach a bit, but I'm confident in our ability to adjust.",
                    "And [BYSTANDER] is off. [NEMESIS], we may need to rethink our roles, but I think we're up for the challenge.",
                    "[BYSTANDER] has left us. [NEMESIS], how do you think we should compensate? I believe we can still perform well.",
                    "Looks like [BYSTANDER] is done for now. [NEMESIS], any ideas on adapting our plan? I'm sure we can make it work.",
                    "[BYSTANDER] has exited the group. [NEMESIS], we might need to reevaluate our strategy, but I'm optimistic about our chances.",
                    "[BYSTANDER] has left the party. [NEMESIS], how should we adjust to this change? I think we have the skills to overcome this.",
                    "And there goes [BYSTANDER]. [NEMESIS], what's your take on our next move? I'm confident we can still succeed.",
                    "[BYSTANDER] has moved on. [NEMESIS], how do you think we should reorganize? I believe we can turn this into an opportunity."
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], I have confidence in our abilities.",
                    "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], I think we've got a good chance at this one.",
                    "[KEYSTONELEVEL] time. [NEMESIS], let's focus on working together effectively.",
                    "Let's do this [KEYSTONELEVEL]. [NEMESIS], I believe we have the skills to succeed.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], remember that good communication will be key to our success.",
                    "We're beginning the [KEYSTONELEVEL]. [NEMESIS], I'm optimistic about our chances.",
                    "[KEYSTONELEVEL] incoming. [NEMESIS], let's show what we're capable of as a team.",
                    "Here we go with the [KEYSTONELEVEL]. [NEMESIS], I think we're well-prepared for this challenge.",
                    "It's [KEYSTONELEVEL] time. [NEMESIS], let's approach this with confidence in our abilities.",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], I'm looking forward to seeing how well we can perform together."
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "We didn't quite make it through that [KEYSTONELEVEL], but I saw some good efforts. [NEMESIS], what do you think went well?",
                    "That [KEYSTONELEVEL] was challenging, but we learned from it. [NEMESIS], what part do you think we improved on?",
                    "We fell short on that [KEYSTONELEVEL], but there were some good moments. [NEMESIS], any positive takeaways?",
                    "[NEMESIS], that [KEYSTONELEVEL] was tough, but I think we made progress. What aspect do you feel we handled better this time?",
                    "We didn't complete the [KEYSTONELEVEL] in time, but I noticed some improvements. [NEMESIS], where do you think we showed the most growth?",
                    "That [KEYSTONELEVEL] didn't work out, but we gained valuable experience. [NEMESIS], what part do you think we understood better this run?",
                    "We missed the timer on that [KEYSTONELEVEL], but there were some strong moments. [NEMESIS], what do you think was our best section?",
                    "That [KEYSTONELEVEL] was a learning experience. [NEMESIS], what positive aspects did you notice in our performance?",
                    "[NEMESIS], we didn't quite make it through that [KEYSTONELEVEL], but I saw potential. What areas do you think we're getting closer on?",
                    "We didn't time the [KEYSTONELEVEL], but I feel we're improving. [NEMESIS], what part of our strategy do you think is starting to come together?"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Great job on timing that [KEYSTONELEVEL]! [NEMESIS], your performance really contributed to our success.",
                    "We did it! [KEYSTONELEVEL] completed in time. [NEMESIS], I noticed some excellent plays from you.",
                    "Excellent work on the [KEYSTONELEVEL], team. [NEMESIS], your skills really shone through in this run.",
                    "Success! [KEYSTONELEVEL] timed. [NEMESIS], you handled your role exceptionally well.",
                    "[KEYSTONELEVEL] completed within the timer. [NEMESIS], your contribution was key to our victory.",
                    "We've successfully timed the [KEYSTONELEVEL]. [NEMESIS], I saw some great decision-making from you.",
                    "That's a timed [KEYSTONELEVEL]! [NEMESIS], you really stepped up when it counted.",
                    "Nicely done on timing the [KEYSTONELEVEL]. [NEMESIS], your performance was crucial to our success.",
                    "[KEYSTONELEVEL] completed successfully. [NEMESIS], you played your role perfectly.",
                    "We've timed the [KEYSTONELEVEL]! [NEMESIS], your efforts really paid off in this run."
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], nice job on watching for casts, let's keep it up.",
                    "I've stopped [TARGET]'s [SPELL]. [NEMESIS], you're doing great with interrupt awareness.",
                    "Just interrupted [TARGET]'s [SPELL]. [NEMESIS], our coordination on interrupts is improving.",
                    "[TARGET]'s [SPELL] interrupted by me. [NEMESIS], I appreciate your attentiveness to castbars.",
                    "Got that interrupt on [TARGET]'s [SPELL]. [NEMESIS], we're getting better at this.",
                    "I've handled [TARGET]'s [SPELL]. [NEMESIS], your interrupt timing has been spot on.",
                    "Managed to interrupt [TARGET]'s [SPELL]. [NEMESIS], we're working well together on these.",
                    "[TARGET]'s [SPELL] stopped. [NEMESIS], our interrupt rotation is getting smoother.",
                    "I've taken care of [TARGET]'s [SPELL]. [NEMESIS], you're doing a great job with interrupt management.",
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], I'm impressed with our interrupt coordination."
                },
                ["NEMESIS"] = {
                    "Excellent interrupt on [TARGET]'s [SPELL], [NEMESIS]. Your timing was perfect.",
                    "Great catch on [TARGET]'s [SPELL], [NEMESIS]. Your awareness is improving.",
                    "Well done interrupting [TARGET]'s [SPELL], [NEMESIS]. That was crucial.",
                    "[NEMESIS], fantastic job stopping [TARGET]'s [SPELL]. You're really on point with these.",
                    "Brilliant interrupt on [TARGET]'s [SPELL], [NEMESIS]. Your reactions are getting faster.",
                    "Superb work catching [TARGET]'s [SPELL], [NEMESIS]. You're really getting the hang of this.",
                    "[NEMESIS], excellent interrupt on [TARGET]'s [SPELL]. Your contribution is making a big difference.",
                    "Great awareness on [TARGET]'s [SPELL], [NEMESIS]. You're becoming quite the interrupt specialist.",
                    "Thanks for handling [TARGET]'s [SPELL], [NEMESIS]. Your interrupt game is strong.",
                    "[NEMESIS], outstanding job on that interrupt of [TARGET]'s [SPELL]. Keep it up!"
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "Dispelled that effect. [NEMESIS], you're doing great at spotting what needs to be removed.",
                    "I've removed that spell. [NEMESIS], our dispel coordination is improving.",
                    "Just dispelled that. [NEMESIS], you're getting better at prioritizing dispels.",
                    "Harmful effect removed by me. [NEMESIS], I appreciate your attentiveness to debuffs.",
                    "Got that dispel. [NEMESIS], we're handling these effects more efficiently now.",
                    "I've handled that dispel. [NEMESIS], your awareness of what needs cleansing is impressive.",
                    "Managed to dispel that effect. [NEMESIS], we're working well together on these.",
                    "That harmful spell has been removed. [NEMESIS], our dispel management is improving.",
                    "I've taken care of that dispel. [NEMESIS], you're doing a great job with debuff awareness.",
                    "Effect dispelled. [NEMESIS], I'm impressed with our coordination on removing harmful spells."
                },
                ["NEMESIS"] = {
                    "Excellent dispel, [NEMESIS]. Your timing was perfect.",
                    "Great removal of that effect, [NEMESIS]. Your awareness is improving.",
                    "Well done on that dispel, [NEMESIS]. That was crucial.",
                    "[NEMESIS], fantastic job removing that harmful spell. You're really on point with these.",
                    "Brilliant dispel work, [NEMESIS]. Your reactions are getting faster.",
                    "Superb job cleansing that effect, [NEMESIS]. You're really getting the hang of this.",
                    "[NEMESIS], excellent dispel. Your contribution is making a big difference.",
                    "Great awareness on that harmful effect, [NEMESIS]. You're becoming quite the dispel specialist.",
                    "Thanks for handling that dispel, [NEMESIS]. Your cleansing game is strong.",
                    "[NEMESIS], outstanding job on that dispel. Keep up the good work!"
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "CC'd that target. [NEMESIS], you're doing great at identifying priority CC targets.",
                    "I've applied crowd control. [NEMESIS], our CC coordination is improving.",
                    "Just CC'd that enemy. [NEMESIS], you're getting better at managing crowd control.",
                    "Crowd control applied by me. [NEMESIS], I appreciate your attentiveness to CC needs.",
                    "Got that CC. [NEMESIS], we're handling crowd control more efficiently now.",
                    "I've handled that crowd control. [NEMESIS], your awareness of CC priorities is impressive.",
                    "Managed to CC that target. [NEMESIS], we're working well together on controlling the fight.",
                    "That mob has been controlled. [NEMESIS], our CC management is improving.",
                    "I've taken care of that CC. [NEMESIS], you're doing a great job with crowd control awareness.",
                    "Crowd control applied. [NEMESIS], I'm impressed with our coordination on managing mobs."
                },
                ["NEMESIS"] = {
                    "Excellent CC, [NEMESIS]. Your timing was perfect.",
                    "Great control of that target, [NEMESIS]. Your awareness is improving.",
                    "Well done on that crowd control, [NEMESIS]. That was crucial.",
                    "[NEMESIS], fantastic job controlling that mob. You're really on point with these.",
                    "Brilliant CC work, [NEMESIS]. Your reactions are getting faster.",
                    "Superb job on that crowd control, [NEMESIS]. You're really getting the hang of this.",
                    "[NEMESIS], excellent CC. Your contribution is making a big difference.",
                    "Great awareness on that crowd control, [NEMESIS]. You're becoming quite the CC specialist.",
                    "Thanks for handling that CC, [NEMESIS]. Your control game is strong.",
                    "[NEMESIS], outstanding job on that crowd control. Keep up the good work!"
                }
            }
        }
    },

    -- Index 7: Moderately positive
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Nice try, [NEMESIS]! We're getting closer with each attempt. Let's keep that momentum going!",
                    "Good effort, [NEMESIS]. We learned a lot from that run. What do you think we should focus on next?",
                    "[NEMESIS], I saw some real improvement there. We're on the right track, don't you think?",
                    "That was better, [NEMESIS]! We're making progress. Any ideas on how to push it further?",
                    "We're getting there, [NEMESIS]! That attempt showed real promise. What shall we refine for next time?",
                    "I'm seeing improvement, [NEMESIS]! What part of the fight do you feel more confident about now?",
                    "That was our best try yet, [NEMESIS]! What do you think was the key to our improved performance?",
                    "We're so close, [NEMESIS]! I can feel it. What do you think could push us over the edge to victory?",
                    "Great effort, [NEMESIS]! We're ironing out the kinks. Any thoughts on our next strategic adjustment?",
                    "That attempt was promising, [NEMESIS]! We're definitely on the right path. What's your take on our progress?"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Oops, my bad there. [NEMESIS], I appreciate your efforts. Any tips for me on the next run?",
                    "Well, I zigged when I should have zagged. [NEMESIS], your support was great. How can I improve?",
                    "[NEMESIS], thanks for having my back. I'll do better next time. Any advice?",
                    "I'll get it right next time. [NEMESIS], your gameplay was solid. Any suggestions for me?",
                    "Learning experience for me. [NEMESIS], I admire your resilience. What would you recommend I change?",
                    "My mistake there. [NEMESIS], I appreciate your patience. How can I better support the team next time?",
                    "I'll aim to avoid that in the future. [NEMESIS], your performance was great. Any insights on better positioning?",
                    "Room for improvement on my part. [NEMESIS], you're doing well. What do you think I should focus on?",
                    "I'll work on that for next time. [NEMESIS], your gameplay is inspiring. Any tips for avoiding that in the future?",
                    "Not my best moment. [NEMESIS], I appreciate your steady performance. How can I better complement your style?"
                },
                ["NEMESIS"] = {
                    "[NEMESIS] gave it their all. Their effort was commendable. How can we honor their contribution?",
                    "We've lost [NEMESIS], but their performance was strong. How do we build on their good work?",
                    "[NEMESIS] fought bravely. Their strategy was sound. What can we learn from their approach?",
                    "[NEMESIS] is down, but they showed real skill. How can we incorporate their tactics?",
                    "[NEMESIS]'s efforts were impressive. Let's use their example to push forward. What's our plan?",
                    "[NEMESIS] gave us their best. Their strategy was clever. How can we adapt it for our next try?",
                    "We've lost [NEMESIS], but not before they made significant progress. How do we capitalize on that?",
                    "[NEMESIS] fought valiantly. Their technique was admirable. What aspects can we adopt?",
                    "[NEMESIS] is down, but they've shown us a path forward. How do we follow through on their strategy?",
                    "[NEMESIS]'s performance was noteworthy. Let's honor their effort by refining our approach. Ideas?"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] is down, but they contributed greatly. [NEMESIS], how can we build on their efforts?",
                    "We've lost [BYSTANDER], but their performance was admirable. [NEMESIS], any thoughts on how to proceed?",
                    "[BYSTANDER] has fallen, but not before making significant progress. [NEMESIS], how should we adapt?",
                    "[BYSTANDER] is out, but they showed real skill. [NEMESIS], how can we incorporate their tactics?",
                    "[BYSTANDER]'s efforts were impressive. [NEMESIS], let's use their example to push forward. What's your take?",
                    "[BYSTANDER] gave it their all. [NEMESIS], their effort was commendable. How can we honor their contribution?",
                    "We've lost [BYSTANDER], but their strategy was sound. [NEMESIS], what can we learn from their approach?",
                    "[BYSTANDER] fought bravely. [NEMESIS], their technique was admirable. What aspects can we adopt?",
                    "[BYSTANDER] is down, but they've shown us a path forward. [NEMESIS], how do we follow through on their strategy?",
                    "[BYSTANDER]'s performance was noteworthy. [NEMESIS], let's honor their effort by refining our approach. Ideas?"
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, let's do this! [NEMESIS], I believe in our ability to overcome this challenge.",
                    "Here we go again. [NEMESIS], I'm confident we can apply what we've learned and succeed.",
                    "Boss time, everyone. [NEMESIS], your improvements have been impressive. Let's show what we can do!",
                    "Let's give it our all. [NEMESIS], your dedication is inspiring. I think this could be our time to shine!",
                    "[NEMESIS], we're getting stronger with each attempt. I have a good feeling about this one!",
                    "Okay, [NEMESIS], we're so close to cracking this. Your perseverance is admirable. Let's make it happen!",
                    "Boss incoming. [NEMESIS], your strategy last time was spot on. Let's refine it and go for the win!",
                    "Here we go. [NEMESIS], I'm excited to see how we'll improve this time. We've got this!",
                    "It's time to face the boss. [NEMESIS], your progress has been remarkable. Let's put it all together!",
                    "[NEMESIS], ready for another round? Your positive attitude is contagious. I think we're on the verge of success!"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Fantastic work, everyone! [NEMESIS], your performance was outstanding. You really stepped up!",
                    "We did it! [NEMESIS], your improvements were key to our victory. Well done!",
                    "Victory at last! [NEMESIS], your perseverance paid off. Your contributions were crucial.",
                    "Great job, team. [NEMESIS], you handled your role exceptionally well. I'm impressed!",
                    "Success! [NEMESIS], your adaptability to the fight mechanics was remarkable. Excellent work!",
                    "We've done it! [NEMESIS], your efforts were instrumental in our triumph. Kudos to you!",
                    "Incredible teamwork, everyone. [NEMESIS], you were really in sync with the group. Your coordination was impeccable!",
                "That's how it's done! [NEMESIS], your focus and execution were spot on. You should be proud!",
                "We've conquered the boss! [NEMESIS], your improvement was evident. You've come so far!",
                "Victory is ours! [NEMESIS], you really rose to the occasion. Your performance was stellar!"
            }
        }
    },
    ["GROUP"] = {
        ["JOIN"] = {
            ["NEMESIS"] = {
                "Welcome to the group, [NEMESIS]! We're thrilled to have you join us. Your skills will be a great asset!",
                "[NEMESIS] has joined us. Excellent! Your reputation precedes you, and we're excited to work with you.",
                "Greetings, [NEMESIS]! We're delighted you could join us. Your expertise will surely enhance our team.",
                "Hey [NEMESIS], welcome aboard! Your addition to the team is going to make this run even more exciting.",
                "[NEMESIS] is here. Fantastic! Your presence is sure to boost our group's performance.",
                "Great to have you with us, [NEMESIS]! Your skills are just what we needed to round out our team.",
                "Welcome, [NEMESIS]! Your joining has really strengthened our group composition. This is going to be fun!",
                "[NEMESIS] has joined the party. Wonderful! Your abilities will complement our team perfectly.",
                "Hey everyone, [NEMESIS] is joining us. This is excellent news! We've got a powerhouse team now.",
                "Welcome to the group, [NEMESIS]. With your expertise on board, I'm confident we'll achieve great things together!"
            },
            ["SELF"] = {
                "Hello, [NEMESIS]! I'm really looking forward to working alongside you. I think we'll make a great team!",
                "Ah, [NEMESIS], it's great to see you again. Your skills always impress me. This should be a fantastic run!",
                "Greetings, [NEMESIS]. I'm excited about the potential of our group with you here. Let's make some magic happen!",
                "[NEMESIS], it's a pleasure to be in a group with you. Your expertise is going to be invaluable.",
                "Hello there, [NEMESIS]. I have a really good feeling about our team's synergy with you on board.",
                "Nice to see you, [NEMESIS]. Your presence really strengthens our group. I'm eager to get started!",
                "[NEMESIS], hello! I'm thrilled about what we can achieve together. Your skills are always impressive.",
                "Greetings, [NEMESIS]. I'm looking forward to seeing how our abilities complement each other. This is going to be great!",
                "Hey [NEMESIS], I'm glad to be grouped with you. Your reputation precedes you, and I'm excited to learn from you.",
                "Hello, [NEMESIS]. I'm really enthusiastic about our potential as a team. Your expertise is going to be crucial to our success!"
            },
            ["BYSTANDER"] = {
                "Welcome, [BYSTANDER]! I'm excited to let you know that [NEMESIS] is also part of our group. We've got a stellar team here!",
                "Hey [BYSTANDER], great to have you join us. With you and [NEMESIS] on board, I think we're in for an amazing run!",
                "[BYSTANDER], welcome to the team! [NEMESIS] is here too, and I'm really looking forward to seeing how we all work together.",
                "Fantastic to have you, [BYSTANDER]. With [NEMESIS] also in our group, I think we've got all the skills we need for success.",
                "Welcome aboard, [BYSTANDER]! Just to let you know, we've got [NEMESIS] with us too. I have a great feeling about our group dynamic!",
                "[BYSTANDER], thanks for joining us. With [NEMESIS] also here, I think we've got a powerhouse team assembled!",
                "Glad you're here, [BYSTANDER]! We've got [NEMESIS] in the team as well. This combination of skills is really exciting!",
                "Hey [BYSTANDER], welcome to the group! [NEMESIS] is also part of our team. I'm thrilled to see how our abilities will complement each other.",
                "[BYSTANDER], welcome aboard! We're also running with [NEMESIS]. I think we have an incredibly well-rounded team here.",
                "Great to see you, [BYSTANDER]! Just so you know, [NEMESIS] is part of our team too. I'm really optimistic about what we can achieve together!"
            }
        },
        ["LEAVE"] = {
            ["NEMESIS"] = {
                "[NEMESIS] has left the group. Thank you so much for your valuable contributions. You really made a difference!",
                "Looks like [NEMESIS] is heading out. It was fantastic having you with us. Your skills were truly impressive!",
                "[NEMESIS] has departed. Thanks for being such an integral part of the team. Your expertise was invaluable!",
                "And [NEMESIS] is off. We really appreciate all your efforts. You've set a high bar for performance!",
                "[NEMESIS] has left us. Thanks for your amazing help. Your strategies and gameplay were top-notch!",
                "Seems [NEMESIS] is moving on. It was an absolute pleasure grouping with you. Your skills are remarkable!",
                "[NEMESIS] has exited the group. Thanks for your outstanding contributions. You've really elevated our gameplay!",
                "Looks like [NEMESIS] is done for now. It was great having you along. Your expertise made a huge impact!",
                "[NEMESIS] has left the party. Thanks for your exceptional help. Your performance was truly impressive!",
                "And there goes [NEMESIS]. We sincerely appreciate your time with us. Your skills and teamwork were exemplary!"
            },
            ["BYSTANDER"] = {
                "[BYSTANDER] has left the group. [NEMESIS], their contributions were valuable, but I'm confident in our ability to adapt and succeed.",
                "Seems [BYSTANDER] is heading out. [NEMESIS], any thoughts on how we should proceed? I'm sure with your skills, we can overcome this change.",
                "[BYSTANDER] has departed. [NEMESIS], this might alter our approach a bit, but I'm excited to see how we can innovate our strategy.",
                "And [BYSTANDER] is off. [NEMESIS], we may need to rethink our roles, but I see this as an opportunity to showcase our versatility.",
                "[BYSTANDER] has left us. [NEMESIS], how do you think we should compensate? I'm confident in our ability to rise to the challenge.",
                "Looks like [BYSTANDER] is done for now. [NEMESIS], any ideas on adapting our plan? I'm sure with your expertise, we can make it work even better.",
                "[BYSTANDER] has exited the group. [NEMESIS], we might need to reevaluate our strategy, but I'm optimistic about our chances with your skills.",
                "[BYSTANDER] has left the party. [NEMESIS], how should we adjust to this change? I think we have the talent to turn this into an advantage.",
                "And there goes [BYSTANDER]. [NEMESIS], what's your take on our next move? I'm confident that with your abilities, we can still achieve great things.",
                "[BYSTANDER] has moved on. [NEMESIS], how do you think we should reorganize? I see this as a chance to demonstrate our adaptability and teamwork."
            }
        }
    },
    ["CHALLENGE"] = {
        ["START"] = {
            ["NA"] = {
                "Alright, let's start this [KEYSTONELEVEL]. [NEMESIS], I have full confidence in our abilities to conquer this challenge!",
                "Here we go, [KEYSTONELEVEL] starting. [NEMESIS], I'm really excited to see how well we can perform together!",
                "[KEYSTONELEVEL] time. [NEMESIS], let's show everyone what we're capable of as a team!",
                "Let's do this [KEYSTONELEVEL]. [NEMESIS], I believe we have the perfect mix of skills to succeed.",
                "[NEMESIS], as we start this [KEYSTONELEVEL], I'm really looking forward to seeing your expertise in action!",
                "We're beginning the [KEYSTONELEVEL]. [NEMESIS], I have a great feeling about our chances with you on the team!",
                "[KEYSTONELEVEL] incoming. [NEMESIS], let's make this run one to remember with your amazing skills!",
                "Here we go with the [KEYSTONELEVEL]. [NEMESIS], I think we're more than prepared for this challenge!",
                "It's [KEYSTONELEVEL] time. [NEMESIS], let's approach this with confidence and showcase our teamwork!",
                "[NEMESIS], as we start this [KEYSTONELEVEL], I'm thrilled to see how well we can coordinate and excel together!"
            }
        },
        ["FAIL"] = {
            ["NA"] = {
                "We may not have timed the [KEYSTONELEVEL], but I saw some great efforts. [NEMESIS], your performance in the last boss fight was impressive!",
                "That [KEYSTONELEVEL] was challenging, but we learned a lot. [NEMESIS], I noticed your crowd control skills have really improved.",
                "We fell short on that [KEYSTONELEVEL], but there were some standout moments. [NEMESIS], your interrupt game was on point!",
                "[NEMESIS], that [KEYSTONELEVEL] was tough, but I was impressed by how well you handled the mechanics on the second boss.",
                "We didn't complete the [KEYSTONELEVEL] in time, but we made progress. [NEMESIS], your DPS on the last trash pack was outstanding!",
                "That [KEYSTONELEVEL] didn't work out, but we gained valuable experience. [NEMESIS], your cooldown usage has really improved.",
                "We missed the timer on that [KEYSTONELEVEL], but there were some strong moments. [NEMESIS], your kiting skills saved us more than once!",
                "That [KEYSTONELEVEL] was a learning experience. [NEMESIS], I was impressed by how quickly you adapted to the affixes.",
                "[NEMESIS], we didn't quite make it through that [KEYSTONELEVEL], but your situational awareness has noticeably improved.",
                "We didn't time the [KEYSTONELEVEL], but I feel we're getting better. [NEMESIS], your communication during critical moments was excellent!"
            }
        },
        ["SUCCESS"] = {
            ["NA"] = {
                "Fantastic job on timing that [KEYSTONELEVEL]! [NEMESIS], your performance was outstanding and really pushed us to victory.",
                "We did it! [KEYSTONELEVEL] completed in time. [NEMESIS], I was really impressed by your skill usage and decision-making.",
                "Excellent work on the [KEYSTONELEVEL], team. [NEMESIS], your expertise really shone through in this run. Well done!",
                "Success! [KEYSTONELEVEL] timed. [NEMESIS], you handled your role exceptionally well. Your contributions were crucial.",
                "[KEYSTONELEVEL] completed within the timer. [NEMESIS], your quick thinking and adaptability were key to our victory.",
                "We've successfully timed the [KEYSTONELEVEL]. [NEMESIS], I saw some fantastic plays from you. Your skills are truly impressive.",
                "That's a timed [KEYSTONELEVEL]! [NEMESIS], you really stepped up when it counted. Your performance was top-notch.",
                "Nicely done on timing the [KEYSTONELEVEL]. [NEMESIS], your gameplay was stellar and really elevated our whole team.",
                "[KEYSTONELEVEL] completed successfully. [NEMESIS], you played your role to perfection. We couldn't have done it without you.",
                "We've timed the [KEYSTONELEVEL]! [NEMESIS], your efforts were outstanding. You should be really proud of your performance."
            }
        }
    },
    ["COMBATLOG"] = {
        ["INTERRUPT"] = {
            ["SELF"] = {
                "Interrupted [TARGET]'s [SPELL]. [NEMESIS], your awareness of cast bars is really improving our overall performance!",
                "I've stopped [TARGET]'s [SPELL]. [NEMESIS], your interrupt coordination with the team is getting better and better!",
                "Just interrupted [TARGET]'s [SPELL]. [NEMESIS], I'm impressed with how well we're timing our interrupts together.",
                "[TARGET]'s [SPELL] interrupted by me. [NEMESIS], your attentiveness to castbars is making our runs so much smoother.",
                "Got that interrupt on [TARGET]'s [SPELL]. [NEMESIS], we're really syncing well on these interrupts!",
                "I've handled [TARGET]'s [SPELL]. [NEMESIS], your interrupt timing has been impeccable. Great job!",
                "Managed to interrupt [TARGET]'s [SPELL]. [NEMESIS], our teamwork on interrupts is really paying off.",
                "[TARGET]'s [SPELL] stopped. [NEMESIS], I'm loving how smooth our interrupt rotation has become.",
                "I've taken care of [TARGET]'s [SPELL]. [NEMESIS], your interrupt management is really enhancing our group's effectiveness.",
                "Interrupted [TARGET]'s [SPELL]. [NEMESIS], I'm really impressed with how well we're coordinating our interrupts."
            },
            ["NEMESIS"] = {
                "Excellent interrupt on [TARGET]'s [SPELL], [NEMESIS]! Your timing was absolutely perfect.",
                "Fantastic catch on [TARGET]'s [SPELL], [NEMESIS]! Your awareness is really impressive.",
                "Brilliant job interrupting [TARGET]'s [SPELL], [NEMESIS]! That was a critical save.",
                "[NEMESIS], outstanding work stopping [TARGET]'s [SPELL]! You're really on top of these interrupts.",
                "Incredible interrupt on [TARGET]'s [SPELL], [NEMESIS]! Your reactions are lightning-fast.",
                "Superb work catching [TARGET]'s [SPELL], [NEMESIS]! You've really mastered the art of interrupting.",
                "[NEMESIS], phenomenal interrupt on [TARGET]'s [SPELL]! Your contributions are making a huge difference.",
                "Amazing awareness on [TARGET]'s [SPELL], [NEMESIS]! You're an interrupt specialist for sure.",
                "Thank you for handling [TARGET]'s [SPELL], [NEMESIS]! Your interrupt game is incredibly strong.",
                "[NEMESIS], that interrupt of [TARGET]'s [SPELL] was top-notch! Keep up the fantastic work!"
            }
        },
        ["DISPEL"] = {
            ["SELF"] = {
                "Dispelled that effect. [NEMESIS], your ability to spot crucial debuffs is really enhancing our survival!",
                "I've removed that spell. [NEMESIS], our dispel coordination is becoming really impressive!",
                "Just dispelled that. [NEMESIS], you're doing an excellent job at prioritizing dispels.",
                "Harmful effect removed by me. [NEMESIS], your attentiveness to debuffs is making our runs so much smoother.",
                "Got that dispel. [NEMESIS], we're handling these effects with great efficiency now!",
                "I've handled that dispel. [NEMESIS], your awareness of what needs cleansing is really impressive.",
                "Managed to dispel that effect. [NEMESIS], our teamwork on dispels is really paying off.",
                "That harmful spell has been removed. [NEMESIS], I'm loving how smooth our dispel management has become.",
                "I've taken care of that dispel. [NEMESIS], your debuff awareness is really enhancing our group's effectiveness.",
                "Effect dispelled. [NEMESIS], I'm really impressed with how well we're coordinating our dispels."
            },
            ["NEMESIS"] = {
                "Excellent dispel, [NEMESIS]! Your timing was absolutely perfect.",
                "Fantastic removal of that effect, [NEMESIS]! Your awareness is really impressive.",
                "Brilliant job on that dispel, [NEMESIS]! That was a critical save.",
                "[NEMESIS], outstanding work removing that harmful spell! You're really on top of these dispels.",
                "Incredible dispel work, [NEMESIS]! Your reactions are lightning-fast.",
                "Superb job cleansing that effect, [NEMESIS]! You've really mastered the art of dispelling.",
                "[NEMESIS], phenomenal dispel! Your contributions are making a huge difference.",
                "Amazing awareness on that harmful effect, [NEMESIS]! You're a dispel specialist for sure.",
                "Thank you for handling that dispel, [NEMESIS]! Your cleansing game is incredibly strong.",
                "[NEMESIS], that dispel was top-notch! Keep up the fantastic work!"
            }
        },
        ["HARDCC"] = {
            ["SELF"] = {
                "CC'd that target. [NEMESIS], your ability to identify priority CC targets is really improving our crowd control!",
                "I've applied crowd control. [NEMESIS], our CC coordination is becoming really impressive!",
                "Just CC'd that enemy. [NEMESIS], you're doing an excellent job at managing crowd control.",
                "Crowd control applied by me. [NEMESIS], your attentiveness to CC needs is making our runs so much smoother.",
                "Got that CC. [NEMESIS], we're handling crowd control with great efficiency now!",
                "I've handled that crowd control. [NEMESIS], your awareness of CC priorities is really impressive.",
                "Managed to CC that target. [NEMESIS], our teamwork on controlling the fight is really paying off.",
                "That mob has been controlled. [NEMESIS], I'm loving how smooth our CC management has become.",
                "I've taken care of that CC. [NEMESIS], your crowd control awareness is really enhancing our group's effectiveness.",
                "Crowd control applied. [NEMESIS], I'm really impressed with how well we're coordinating our CC."
            },
            ["NEMESIS"] = {
                "Excellent CC, [NEMESIS]! Your timing was absolutely perfect.",
                "Fantastic control of that target, [NEMESIS]! Your awareness is really impressive.",
                "Brilliant job on that crowd control, [NEMESIS]! That was a critical save.",
                "[NEMESIS], outstanding work controlling that mob! You're really on top of these CCs.",
                "Incredible CC work, [NEMESIS]! Your reactions are lightning-fast.",
                "Superb job on that crowd control, [NEMESIS]! You've really mastered the art of CC.",
                "[NEMESIS], phenomenal CC! Your contributions are making a huge difference.",
                "Amazing awareness on that crowd control, [NEMESIS]! You're a CC specialist for sure.",
                "Thank you for handling that CC, [NEMESIS]! Your control game is incredibly strong.",
                "[NEMESIS], that crowd control was top-notch! Keep up the fantastic work!"
            }
        }
    }
},

    -- Index 8: Very positive
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "Excellent effort, [NEMESIS]! We're so close to cracking this. Your perseverance is inspiring!",
                    "Great work, [NEMESIS]! That was our best attempt yet. Your strategies are really paying off!",
                    "[NEMESIS], your performance was outstanding! We've made huge strides thanks to your input.",
                    "Impressive run, [NEMESIS]! We're on the verge of success, and it's largely thanks to your contributions.",
                    "Fantastic attempt, [NEMESIS]! Your skill is evident, and we're all improving because of it.",
                    "Incredible progress, [NEMESIS]! Your adaptability is remarkable. We're so close to victory!",
                    "Brilliant effort, [NEMESIS]! Your strategic insights are invaluable. We'll nail it next time!",
                    "Amazing try, [NEMESIS]! Your dedication is paying off. We're right on the edge of success!",
                    "Superb attempt, [NEMESIS]! Your skill growth is impressive. Victory is within our grasp!",
                    "Phenomenal work, [NEMESIS]! Your leadership in that attempt was inspiring. We're almost there!"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "My mistake there, but [NEMESIS], your support was incredible. I'm learning so much from you!",
                    "I'll do better next time, inspired by your excellent play, [NEMESIS]. Any final tips for me?",
                    "[NEMESIS], your performance was flawless. I'll strive to match your level next attempt!",
                    "I may have fallen, but [NEMESIS], your gameplay was phenomenal. I'm in awe of your skills!",
                    "A setback for me, but [NEMESIS], you're carrying us brilliantly. Your expertise is invaluable!",
                    "I'll improve from this, [NEMESIS]. Your flawless execution is setting a high bar for us all!",
                    "My error there, but [NEMESIS], your strategic play is enlightening. I'm taking notes!",
                    "I'll learn from this mistake. [NEMESIS], your performance continues to impress me!",
                    "A misstep on my part, but [NEMESIS], your gameplay is truly inspirational. I'm motivated to do better!",
                    "I'll bounce back from this. [NEMESIS], your skill and poise under pressure are admirable!"
                },
                ["NEMESIS"] = {
                    "[NEMESIS] fought valiantly. Their strategy was brilliant, and we'll carry on in their spirit!",
                    "We've lost [NEMESIS], but their exceptional performance has set us up for success. Let's make them proud!",
                    "[NEMESIS] showcased extraordinary skill. We're honored to have fought alongside them. How can we best follow their example?",
                    "Though [NEMESIS] has fallen, their incredible tactics have given us a clear path to victory. Let's seize this opportunity!",
                    "[NEMESIS]'s remarkable efforts have brought us to the brink of success. We'll triumph in their honor!",
                    "[NEMESIS]'s performance was nothing short of heroic. Their strategies will guide us to victory!",
                    "We've lost [NEMESIS], but their brilliant play has shown us the way. Let's finish what they started!",
                    "[NEMESIS] displayed unparalleled skill before falling. Their tactics will be the key to our success!",
                    "Though [NEMESIS] is down, their exceptional performance has paved our path to victory. Let's not let their efforts be in vain!",
                    "[NEMESIS]'s incredible gameplay, even in defeat, has given us the blueprint for success. We'll win this for them!"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has fallen, but their contributions were invaluable. [NEMESIS], how can we best honor their efforts?",
                    "We've lost [BYSTANDER], but their performance was exceptional. [NEMESIS], how do you suggest we build on their strategy?",
                    "[BYSTANDER] showcased remarkable skill before falling. [NEMESIS], how can we incorporate their tactics into our approach?",
                    "Though [BYSTANDER] is down, their brilliant play has given us an advantage. [NEMESIS], how should we capitalize on this?",
                    "[BYSTANDER]'s efforts were truly inspirational. [NEMESIS], what's your take on how we can carry forward their momentum?",
                    "[BYSTANDER] fought heroically. [NEMESIS], how can we best utilize the openings they've created for us?",
                    "We've lost [BYSTANDER], but their strategic insights were crucial. [NEMESIS], how do you think we should adapt our plan?",
                    "[BYSTANDER] displayed exceptional skill until the end. [NEMESIS], what aspects of their approach should we emulate?",
                    "Though [BYSTANDER] has fallen, their performance was top-notch. [NEMESIS], how can we ensure their efforts weren't in vain?",
                    "[BYSTANDER]'s gameplay was outstanding. [NEMESIS], how do you suggest we adjust our strategy to complement their contributions?"
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Alright, team, let's do this! [NEMESIS], your strategic insights have been invaluable. I'm excited to see us put them into action!",
                    "Here we go again, and I couldn't be more optimistic! [NEMESIS], your improvements have been phenomenal. Let's show what we've learned!",
                    "Boss time, everyone. [NEMESIS], your leadership has been inspiring. I'm confident this attempt will be our best yet!",
                    "Let's give it our all! [NEMESIS], your dedication is truly motivating. I believe this could be the run where it all comes together!",
                    "[NEMESIS], we're stronger than ever thanks to your contributions. I have an excellent feeling about this attempt!",
                    "Okay, [NEMESIS], we're on the cusp of victory, largely thanks to your efforts. Let's make this the defining moment!",
                    "Boss incoming. [NEMESIS], your strategies have been game-changing. I'm thrilled to see how we execute them this time!",
                    "Here we go. [NEMESIS], your progress has been remarkable. I'm confident this attempt will showcase all we've achieved!",
                    "It's time to face the boss. [NEMESIS], your skill growth has been phenomenal. Let's put it all together and claim our victory!",
                    "[NEMESIS], ready for another round? Your positive attitude and expertise have brought us so far. I believe this is our moment to shine!"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Incredible victory, everyone! [NEMESIS], your performance was absolutely stellar. You were the linchpin of our success!",
                    "We did it! [NEMESIS], your exceptional skills and leadership were instrumental in this triumph. Phenomenal job!",
                    "Victory is ours! [NEMESIS], your strategic brilliance and flawless execution were the keys to our success. Outstanding work!",
                    "Amazing job, team! [NEMESIS], you truly outdid yourself this time. Your expertise made this victory possible!",
                    "Success at last! [NEMESIS], your adaptability and skill were nothing short of remarkable. You should be incredibly proud!",
                    "We've conquered the challenge! [NEMESIS], your contributions were pivotal in this victory. Exceptional performance!",
                    "Fantastic teamwork, everyone! [NEMESIS], your coordination and skill were off the charts. You've set a new standard for excellence!",
                    "That's how it's done! [NEMESIS], your focus and execution were impeccable. You've truly mastered this encounter!",
                    "We've triumphed over the boss! [NEMESIS], your growth and expertise were on full display. You've come so far and it shows!",
                    "Victory is sweet! [NEMESIS], you were the MVP of this fight. Your performance was nothing short of legendary!"
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Welcome to the group, [NEMESIS]! We're absolutely thrilled to have a player of your caliber join us. Your skills are going to be a game-changer!",
                    "[NEMESIS] has joined us. What an honor! Your reputation for excellence precedes you, and we're excited to witness your expertise firsthand.",
                    "Greetings, [NEMESIS]! We're overjoyed you could join us. Your renowned skills are exactly what we needed to take our team to the next level.",
                    "Hey [NEMESIS], welcome aboard! Your addition to the team is incredibly exciting. We're looking forward to some truly epic runs with you!",
                    "[NEMESIS] is here. Fantastic! Your presence is sure to elevate our group's performance to new heights. We're lucky to have you!",
                    "Great to have you with us, [NEMESIS]! Your exceptional abilities are just what we needed to round out our dream team. This is going to be amazing!",
                    "Welcome, [NEMESIS]! Your joining has truly perfected our group composition. We're set for some legendary adventures with you on board!",
                    "[NEMESIS] has joined the party. Wonderful! Your unparalleled skills will complement our team perfectly. We're in for some incredible runs!",
                    "Hey everyone, [NEMESIS] is joining us. This is phenomenal news! We've just become an unstoppable force with you in our ranks.",
                    "Welcome to the group, [NEMESIS]. With your world-class expertise on our side, I'm confident we'll achieve feats we've only dreamed of before!"
                },
                ["SELF"] = {
                    "Hello, [NEMESIS]! I'm absolutely thrilled to be working alongside you. Your skills are legendary, and I know we'll make an unstoppable team!",
                    "Ah, [NEMESIS], it's an honor to see you again. Your expertise never fails to impress me. I'm certain this will be our most successful run yet!",
                    "Greetings, [NEMESIS]. I'm beyond excited about the potential of our group with you here. Together, we're going to set new records!",
                    "[NEMESIS], it's a true pleasure to be in a group with you. Your unparalleled expertise is going to be the key to our success.",
                    "Hello there, [NEMESIS]. I have an incredibly good feeling about our team's synergy with you on board. We're destined for greatness!",
                    "Nice to see you, [NEMESIS]. Your presence really elevates our group to elite status. I'm eager to learn from your mastery!",
                    "[NEMESIS], hello! I'm absolutely thrilled about what we can achieve together. Your skills are truly in a league of their own.",
                    "Greetings, [NEMESIS]. I'm looking forward to seeing how our abilities complement each other. With your expertise, we're unstoppable!",
                    "Hey [NEMESIS], I'm honored to be grouped with you. Your legendary reputation is well-deserved, and I'm excited to see you in action!",
                    "Hello, [NEMESIS]. I'm incredibly enthusiastic about our potential as a team. Your world-class expertise is going to lead us to unprecedented victories!"
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]! I'm thrilled to inform you that [NEMESIS] is also part of our group. We've assembled a truly elite team here!",
                    "Hey [BYSTANDER], it's fantastic to have you join us. With you and the legendary [NEMESIS] on board, I'm certain we're in for some record-breaking runs!",
                    "[BYSTANDER], welcome to the team! The renowned [NEMESIS] is here too, and I'm incredibly excited to see how our combined expertise will lead us to victory.",
                    "It's great to have you, [BYSTANDER]. With [NEMESIS]'s unparalleled skills also in our group, I believe we've formed the perfect team for any challenge.",
                    "Welcome aboard, [BYSTANDER]! I'm delighted to let you know that we've also got the exceptional [NEMESIS] with us. Our group's potential is truly limitless!",
                    "[BYSTANDER], thanks for joining us. With [NEMESIS]'s legendary abilities in our team too, I'm confident we've assembled one of the most formidable groups ever!",
                    "Glad you're here, [BYSTANDER]! We've got the incomparable [NEMESIS] in the team as well. This combination of skills is absolutely thrilling!",
                    "Hey [BYSTANDER], welcome to the group! The esteemed [NEMESIS] is also part of our team. I'm beyond excited to see how our diverse talents will synergize for incredible results!",
                    "[BYSTANDER], welcome aboard! We're also running with the masterful [NEMESIS]. I truly believe we have one of the most well-rounded and skilled teams ever assembled.",
                    "Great to see you, [BYSTANDER]! Just so you know, the exceptional [NEMESIS] is part of our team too. I'm absolutely confident that together, we'll achieve feats beyond our wildest expectations!"
                }
            },
            ["LEAVE"] = {
                ["NEMESIS"] = {
                    "[NEMESIS] has left the group. Thank you so much for your invaluable contributions. Your exceptional skills truly elevated our entire team!",
                    "Looks like [NEMESIS] is heading out. It was an absolute honor having you with us. Your expertise was truly awe-inspiring!",
                    "[NEMESIS] has departed. Thank you for being such a cornerstone of our team. Your unparalleled abilities made a tremendous impact!",
                    "And [NEMESIS] is off. We're incredibly grateful for all your extraordinary efforts. You've set a new standard for excellence!",
                    "[NEMESIS] has left us. Thank you for your phenomenal help. Your strategies and gameplay were nothing short of revolutionary!",
                    "Seems [NEMESIS] is moving on. It was a privilege and a joy to group with you. Your skills are truly in a league of their own!",
                    "[NEMESIS] has exited the group. Thank you for your outstanding contributions. You've not only elevated our gameplay but inspired us all!",
                    "Looks like [NEMESIS] is done for now. It was an incredible experience having you along. Your expertise has left an indelible mark on our team!",
                    "[NEMESIS] has left the party. Thank you for your exceptional help. Your performance was consistently breathtaking and motivating!",
                    "And there goes [NEMESIS]. We're profoundly grateful for your time with us. Your skills, teamwork, and leadership were truly exemplary and unforgettable!"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has left the group. [NEMESIS], their contributions were fantastic, but I'm absolutely confident in our ability to adapt and excel with your exceptional skills!",
                    "Seems [BYSTANDER] is heading out. [NEMESIS], any thoughts on how we should proceed? I'm certain that with your unparalleled abilities, we'll overcome this change brilliantly!",
                    "[BYSTANDER] has departed. [NEMESIS], this might alter our approach a bit, but I'm thrilled to see how we can innovate our strategy with your expertise!",
                    "And [BYSTANDER] is off. [NEMESIS], we may need to rethink our roles, but I see this as an exciting opportunity to showcase your versatility and mastery!",
                    "[BYSTANDER] has left us. [NEMESIS], how do you think we should compensate? I'm fully confident in our ability to rise to the challenge with your incredible skills!",
                    "Looks like [BYSTANDER] is done for now. [NEMESIS], any ideas on adapting our plan? I'm certain that with your exceptional expertise, we can make it work even better than before!",
                    "[BYSTANDER] has exited the group. [NEMESIS], we might need to reevaluate our strategy, but I'm extremely optimistic about our chances with your unmatched abilities!",
                    "[BYSTANDER] has left the party. [NEMESIS], how should we adjust to this change? I'm convinced we have the talent to turn this into a significant advantage with your leadership!",
                    "And there goes [BYSTANDER]. [NEMESIS], what's your take on our next move? I'm absolutely confident that with your remarkable skills, we can still achieve extraordinary things!",
                    "[BYSTANDER] has moved on. [NEMESIS], how do you think we should reorganize? I see this as an exciting opportunity to demonstrate your adaptability and unparalleled teamwork!"
                }
            }
        },
        ["CHALLENGE"] = {
            ["START"] = {
                ["NA"] = {
                    "Alright, let's conquer this [KEYSTONELEVEL]! [NEMESIS], your exceptional abilities give me complete confidence in our success!",
                    "Here we go, [KEYSTONELEVEL] starting! [NEMESIS], I'm absolutely thrilled to see how your expertise will shine in this challenge!",
                    "[KEYSTONELEVEL] time! [NEMESIS], let's show everyone the incredible synergy and skill of our team!",
                    "Let's dominate this [KEYSTONELEVEL]! [NEMESIS], I believe your unparalleled skills are the perfect recipe for our triumph!",
                    "[NEMESIS], as we embark on this [KEYSTONELEVEL], I'm beyond excited to witness your mastery in action!",
                    "We're kicking off the [KEYSTONELEVEL]! [NEMESIS], your presence gives me unwavering confidence in our ability to excel!",
                    "[KEYSTONELEVEL] incoming! [NEMESIS], let's make this run legendary with your amazing abilities!",
                    "Here we go with the [KEYSTONELEVEL]! [NEMESIS], I'm certain your expertise will guide us to an impressive victory!",
                    "It's [KEYSTONELEVEL] time! [NEMESIS], let's approach this with the confidence that your exceptional skills inspire in all of us!",
                    "[NEMESIS], as we start this [KEYSTONELEVEL], I'm filled with enthusiasm about how spectacularly we'll perform with your leadership!"
                }
            },
            ["FAIL"] = {
                ["NA"] = {
                    "We may not have timed the [KEYSTONELEVEL], but [NEMESIS], your performance was truly outstanding! Your skill in the last boss fight was nothing short of inspirational!",
                    "That [KEYSTONELEVEL] was challenging, but [NEMESIS], I was in awe of your abilities throughout. Your crowd control skills have reached a new level of mastery!",
                    "We fell short on that [KEYSTONELEVEL], but [NEMESIS], there were moments of pure brilliance from you. Your interrupt game was absolutely flawless!",
                    "[NEMESIS], that [KEYSTONELEVEL] was tough, but I was thoroughly impressed by your exceptional handling of mechanics on the second boss. Your expertise shone through!",
                    "We didn't complete the [KEYSTONELEVEL] in time, but [NEMESIS], your performance was stellar. Your DPS on the last trash pack was mind-blowingly high!",
                    "That [KEYSTONELEVEL] didn't work out, but [NEMESIS], your play was exemplary throughout. Your cooldown usage was nothing short of perfection!",
                    "We missed the timer on that [KEYSTONELEVEL], but [NEMESIS], your kiting skills were absolutely phenomenal. You single-handedly saved us multiple times!",
                    "That [KEYSTONELEVEL] was a learning experience, and [NEMESIS], I was amazed by how quickly you adapted to the affixes. Your gameplay was truly next-level!",
                    "[NEMESIS], we didn't quite make it through that [KEYSTONELEVEL], but your situational awareness was extraordinary. You anticipated and reacted to every mechanic flawlessly!",
                    "We didn't time the [KEYSTONELEVEL], but [NEMESIS], your communication during critical moments was exceptional. Your calls were precise and invaluable!"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Phenomenal job on timing that [KEYSTONELEVEL]! [NEMESIS], your performance was absolutely breathtaking and truly instrumental to our victory!",
                    "We did it! [KEYSTONELEVEL] completed in time. [NEMESIS], I was completely blown away by your skill usage and decision-making. You're in a league of your own!",
                    "Extraordinary work on the [KEYSTONELEVEL], team. [NEMESIS], your expertise was simply unmatched in this run. You've set a new standard for excellence!",
                    "Success! [KEYSTONELEVEL] timed. [NEMESIS], you handled your role with unparalleled mastery. Your contributions were absolutely crucial and awe-inspiring!",
                    "[KEYSTONELEVEL] completed within the timer. [NEMESIS], your lightning-fast thinking and adaptability were the cornerstone of our triumph. Incredible job!",
                    "We've successfully timed the [KEYSTONELEVEL]. [NEMESIS], I witnessed some truly legendary plays from you. Your skills are genuinely inspirational!",
                    "That's a timed [KEYSTONELEVEL]! [NEMESIS], you elevated the entire team's performance. Your gameplay was nothing short of perfection!",
                    "Brilliantly done on timing the [KEYSTONELEVEL]. [NEMESIS], your performance was utterly stellar and pushed our whole team to new heights!",
                    "[KEYSTONELEVEL] completed successfully. [NEMESIS], you played your role with absolute perfection. We couldn't have achieved this without your exceptional skills!",
                    "We've timed the [KEYSTONELEVEL]! [NEMESIS], your efforts were truly extraordinary. Your performance today was legendary and will be remembered for a long time!"
                }
            }
        },
        ["COMBATLOG"] = {
            ["INTERRUPT"] = {
                ["SELF"] = {
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], your exceptional awareness of cast bars is elevating our performance to new heights!",
                    "I've stopped [TARGET]'s [SPELL]. [NEMESIS], your interrupt coordination with the team is absolutely flawless!",
                    "Just interrupted [TARGET]'s [SPELL]. [NEMESIS], I'm in awe of how perfectly we're timing our interrupts together. Your expertise is showing!",
                    "[TARGET]'s [SPELL] interrupted by me. [NEMESIS], your attentiveness to castbars is making our runs incredibly smooth. It's impressive!",
                    "Got that interrupt on [TARGET]'s [SPELL]. [NEMESIS], our interrupt synergy is reaching new levels of perfection!",
                    "I've handled [TARGET]'s [SPELL]. [NEMESIS], your interrupt timing has been absolutely impeccable. You're setting a new standard!",
                    "Managed to interrupt [TARGET]'s [SPELL]. [NEMESIS], our teamwork on interrupts is paying off tremendously. Your skill is evident!",
                    "[TARGET]'s [SPELL] stopped. [NEMESIS], I'm amazed at how seamless our interrupt rotation has become. Your contribution is invaluable!",
                    "I've taken care of [TARGET]'s [SPELL]. [NEMESIS], your interrupt management is truly enhancing our group's effectiveness. It's remarkable!",
                    "Interrupted [TARGET]'s [SPELL]. [NEMESIS], I'm thoroughly impressed with how masterfully we're coordinating our interrupts. Your expertise shines!"
                },
                ["NEMESIS"] = {
                    "Absolutely brilliant interrupt on [TARGET]'s [SPELL], [NEMESIS]! Your timing was perfection incarnate!",
                    "Incredible catch on [TARGET]'s [SPELL], [NEMESIS]! Your awareness is truly awe-inspiring!",
                    "Phenomenal job interrupting [TARGET]'s [SPELL], [NEMESIS]! That was a game-changing save!",
                    "[NEMESIS], your interrupt on [TARGET]'s [SPELL] was nothing short of miraculous! Your mastery of these mechanics is unparalleled!",
                    "Spectacular interrupt on [TARGET]'s [SPELL], [NEMESIS]! Your lightning-fast reactions are setting a new standard!",
                    "Masterful work catching [TARGET]'s [SPELL], [NEMESIS]! You've truly perfected the art of interrupting!",
                    "[NEMESIS], that interrupt on [TARGET]'s [SPELL] was absolutely world-class! Your contributions are elevating our entire team!",
                    "Extraordinary awareness on [TARGET]'s [SPELL], [NEMESIS]! You're not just an interrupt specialist, you're the interrupt master!",
                    "I'm in awe of how you handled [TARGET]'s [SPELL], [NEMESIS]! Your interrupt game is beyond impressive, it's revolutionary!",
                    "[NEMESIS], that interrupt of [TARGET]'s [SPELL] was simply breathtaking! Your skill level is truly in a league of its own!"
                }
            },
            ["DISPEL"] = {
                ["SELF"] = {
                    "Dispelled that effect. [NEMESIS], your remarkable ability to spot crucial debuffs is taking our survival to the next level!",
                    "I've removed that spell. [NEMESIS], our dispel coordination has reached a level of synergy that's truly impressive!",
                    "Just dispelled that. [NEMESIS], you're doing an phenomenal job at prioritizing dispels. Your expertise is evident!",
                    "Harmful effect removed by me. [NEMESIS], your attentiveness to debuffs is making our runs incredibly smooth. It's impressive!",
                    "Got that dispel. [NEMESIS], we're handling these effects with an efficiency that's nothing short of amazing!",
                    "I've handled that dispel. [NEMESIS], your awareness of what needs cleansing is truly remarkable. You're setting the standard!",
                    "Managed to dispel that effect. [NEMESIS], our teamwork on dispels is yielding extraordinary results. Your skill is clear!",
                    "That harmful spell has been removed. [NEMESIS], I'm amazed at how seamless our dispel management has become. Your contribution is invaluable!",
                    "I've taken care of that dispel. [NEMESIS], your debuff awareness is elevating our group's effectiveness to new heights. It's remarkable!",
                    "Effect dispelled. [NEMESIS], I'm thoroughly impressed with how masterfully we're coordinating our dispels. Your expertise truly shines!"
                },
                ["NEMESIS"] = {
                    "Absolutely brilliant dispel, [NEMESIS]! Your timing was perfection incarnate!",
                    "Incredible removal of that effect, [NEMESIS]! Your awareness is truly awe-inspiring!",
                    "Phenomenal job on that dispel, [NEMESIS]! That was a game-changing save!",
                    "[NEMESIS], your removal of that harmful spell was nothing short of miraculous! Your mastery of these mechanics is unparalleled!",
                    "Spectacular dispel work, [NEMESIS]! Your lightning-fast reactions are setting a new standard!",
                    "Masterful job cleansing that effect, [NEMESIS]! You've truly perfected the art of dispelling!",
                    "[NEMESIS], that dispel was absolutely world-class! Your contributions are elevating our entire team!",
                    "Extraordinary awareness on that harmful effect, [NEMESIS]! You're not just a dispel specialist, you're the dispel master!",
                    "I'm in awe of how you handled that dispel, [NEMESIS]! Your cleansing game is beyond impressive, it's revolutionary!",
                    "[NEMESIS], that dispel was simply breathtaking! Your skill level is truly in a league of its own!"
                }
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "CC'd that target. [NEMESIS], your exceptional ability to identify priority CC targets is elevating our control to new heights!",
                    "I've applied crowd control. [NEMESIS], our CC coordination has reached a level of synergy that's truly impressive!",
                    "Just CC'd that enemy. [NEMESIS], you're doing a phenomenal job at managing crowd control. Your expertise is evident!",
                    "Crowd control applied by me. [NEMESIS], your attentiveness to CC needs is making our runs incredibly smooth. It's impressive!",
                    "Got that CC. [NEMESIS], we're handling crowd control with an efficiency that's nothing short of amazing!",
                    "I've handled that crowd control. [NEMESIS], your awareness of CC priorities is truly remarkable. You're setting the standard!",
                    "Managed to CC that target. [NEMESIS], our teamwork on controlling the fight is yielding extraordinary results. Your skill is clear!",
                    "That mob has been controlled. [NEMESIS], I'm amazed at how seamless our CC management has become. Your contribution is invaluable!",
                    "I've taken care of that CC. [NEMESIS], your crowd control awareness is elevating our group's effectiveness to new heights. It's remarkable!",
                    "Crowd control applied. [NEMESIS], I'm thoroughly impressed with how masterfully we're coordinating our CC. Your expertise truly shines!"
                },
                ["NEMESIS"] = {
                    "Absolutely brilliant CC, [NEMESIS]! Your timing was perfection incarnate!",
                    "Incredible control of that target, [NEMESIS]! Your awareness is truly awe-inspiring!",
                    "Phenomenal job on that crowd control, [NEMESIS]! That was a game-changing move!",
                    "[NEMESIS], your CC on that mob was nothing short of miraculous! Your mastery of these mechanics is unparalleled!",
                    "Spectacular CC work, [NEMESIS]! Your lightning-fast reactions are setting a new standard!",
                    "Masterful job on that crowd control, [NEMESIS]! You've truly perfected the art of CC!",
                    "[NEMESIS], that CC was absolutely world-class! Your contributions are elevating our entire team!",
                    "Extraordinary awareness on that crowd control, [NEMESIS]! You're not just a CC specialist, you're the CC master!",
                    "I'm in awe of how you handled that CC, [NEMESIS]! Your control game is beyond impressive, it's revolutionary!",
                    "[NEMESIS], that crowd control was simply breathtaking! Your skill level is truly in a league of its own!"
                }
            }
        }
    },

    -- Index 9: Extremely positive (just short of the most friendly in index 10)
    {
        ["BOSS"] = {
            ["FAIL"] = {
                ["NA"] = {
                    "[NEMESIS], your performance was absolutely stellar! We're on the cusp of victory thanks to your amazing skills!",
                    "Incredible work, [NEMESIS]! Your expertise has transformed our group. Success is within our grasp!",
                    "[NEMESIS], I'm in awe of your abilities! Your strategies have elevated our entire team. We're so close to triumph!",
                    "Phenomenal effort, [NEMESIS]! Your leadership and skill are unparalleled. Victory is just around the corner!",
                    "Outstanding run, [NEMESIS]! Your mastery of this encounter is evident. We're poised for success thanks to you!",
                    "[NEMESIS], your performance was breathtaking! We've made enormous strides thanks to your brilliant input.",
                    "Extraordinary attempt, [NEMESIS]! Your skill and adaptability are truly inspirational. We're on the brink of victory!",
                    "Magnificent effort, [NEMESIS]! Your strategic insights are invaluable. I'm certain we'll nail it on the next try!",
                    "Spectacular try, [NEMESIS]! Your dedication and skill growth are awe-inspiring. Success is within our reach!",
                    "Astounding work, [NEMESIS]! Your leadership in that attempt was truly inspiring. We're so close to achieving greatness!"
                }
            },
            ["DEATH"] = {
                ["SELF"] = {
                    "Even in defeat, I'm inspired by your incredible performance, [NEMESIS]. Your skills are truly aspirational!",
                    "[NEMESIS], your flawless execution is a joy to witness. I'm honored to fight alongside such a skilled player!",
                    "I may have fallen, but [NEMESIS], your extraordinary gameplay gives me hope. You're the backbone of our team!",
                    "My mistake pales in comparison to your brilliant strategy, [NEMESIS]. Your expertise is guiding us to victory!",
                    "[NEMESIS], your unparalleled skill shines even in the face of challenges. I'm continually amazed by your abilities!",
                    "Though I've fallen, [NEMESIS], your masterful play is a beacon of hope. Your expertise is truly inspiring!",
                    "My error seems insignificant next to your strategic brilliance, [NEMESIS]. You're leading us to certain victory!",
                    "[NEMESIS], even as I've faltered, your exceptional skill continues to amaze me. You're the cornerstone of our success!",
                    "I may be down, but [NEMESIS], your outstanding performance fills me with confidence. You're carrying us to triumph!",
                    "Despite my setback, [NEMESIS], your phenomenal gameplay keeps our hopes high. Your mastery is truly awe-inspiring!"
                },
                ["NEMESIS"] = {
                    "[NEMESIS]'s heroic stand was nothing short of legendary. Their sacrifice has paved our way to certain victory!",
                    "We've lost our brightest star, [NEMESIS], but their radiant performance will light our path to triumph!",
                    "[NEMESIS] displayed unmatched prowess until the very end. Their extraordinary legacy will fuel our inevitable success!",
                    "Though [NEMESIS] has fallen, their awe-inspiring strategy lives on. We'll achieve greatness in their honor!",
                    "[NEMESIS]'s breathtaking efforts have all but guaranteed our victory. Let's make their valiant fight count!",
                    "[NEMESIS]'s incredible performance, even in defeat, has shown us the path to victory. We'll triumph in their name!",
                    "We've lost [NEMESIS], but their brilliant tactics have set the stage for our success. Let's honor their memory with victory!",
                    "[NEMESIS] fought with unparalleled skill and courage. Their inspiring strategy will lead us to ultimate triumph!",
                    "Though [NEMESIS] has fallen, their extraordinary efforts have brought us to the threshold of victory. We'll succeed for them!",
                    "[NEMESIS]'s awe-inspiring gameplay, even in their final moments, has given us the key to success. We'll win this in their honor!"
                },
                ["BYSTANDER"] = {
                    "[BYSTANDER] has fallen, but their contributions were truly extraordinary. [NEMESIS], how can we best honor their remarkable efforts?",
                    "We've lost [BYSTANDER], but their performance was nothing short of phenomenal. [NEMESIS], how do you suggest we build on their brilliant strategy?",
                    "[BYSTANDER] showcased unparalleled skill before falling. [NEMESIS], how can we incorporate their exceptional tactics into our approach?",
                    "Though [BYSTANDER] is down, their awe-inspiring play has given us a significant advantage. [NEMESIS], how should we capitalize on this?",
                    "[BYSTANDER]'s efforts were truly legendary. [NEMESIS], what's your take on how we can carry forward their incredible momentum?",
                    "[BYSTANDER] fought with unmatched heroism. [NEMESIS], how can we best utilize the extraordinary openings they've created for us?",
                    "We've lost [BYSTANDER], but their strategic brilliance was crucial. [NEMESIS], how do you think we should adapt our plan to honor their insight?",
                    "[BYSTANDER] displayed exceptional mastery until the end. [NEMESIS], what aspects of their remarkable approach should we emulate?",
                    "Though [BYSTANDER] has fallen, their performance was absolutely top-tier. [NEMESIS], how can we ensure their incredible efforts weren't in vain?",
                    "[BYSTANDER]'s gameplay was truly inspirational. [NEMESIS], how do you suggest we adjust our strategy to complement their outstanding contributions?"
                }
            },
            ["START"] = {
                ["NA"] = {
                    "Team, let's make history! [NEMESIS], your unparalleled strategic insights have prepared us for greatness. I'm thrilled to see us put them into action!",
                    "Here we go again, and I couldn't be more excited! [NEMESIS], your phenomenal improvements have been truly inspiring. Let's showcase everything we've learned!",
                    "Boss time, everyone. [NEMESIS], your exemplary leadership has been nothing short of revolutionary. I'm certain this attempt will be our crowning achievement!",
                    "Let's give it our absolute all! [NEMESIS], your unwavering dedication is profoundly motivating. I believe this will be the run where everything falls perfectly into place!",
                    "[NEMESIS], we're stronger than ever thanks to your invaluable contributions. I have an overwhelmingly positive feeling about this attempt!",
                    "Okay, [NEMESIS], we're on the precipice of victory, largely due to your extraordinary efforts. Let's make this the defining moment of our journey!",
                    "Boss incoming. [NEMESIS], your strategies have been absolutely game-changing. I'm beyond excited to see how flawlessly we execute them this time!",
                    "Here we go. [NEMESIS], your progress has been nothing short of miraculous. I'm fully confident this attempt will showcase all we've achieved and more!",
                    "It's time to face the boss. [NEMESIS], your skill growth has been truly phenomenal. Let's put it all together and claim our well-deserved victory!",
                    "[NEMESIS], ready for another round? Your positive attitude and unmatched expertise have brought us incredibly far. I firmly believe this is our moment to shine and make history!"
                }
            },
            ["SUCCESS"] = {
                ["NA"] = {
                    "Phenomenal victory, everyone! [NEMESIS], your performance was absolutely legendary. You were the driving force behind our incredible success!",
                    "We did it! [NEMESIS], your exceptional skills and inspiring leadership were the cornerstone of this magnificent triumph. Truly outstanding work!",
                    "Victory is ours! [NEMESIS], your strategic brilliance and flawless execution were the keys to our resounding success. Your performance was simply breathtaking!",
                    "Amazing job, team! [NEMESIS], you truly outdid yourself this time. Your unparalleled expertise made this victory not just possible, but spectacular!",
                    "Success at last! [NEMESIS], your adaptability and skill were nothing short of miraculous. You should be incredibly proud of your pivotal role in this achievement!",
                    "We've conquered the challenge! [NEMESIS], your contributions were absolutely crucial in this victory. Your performance was nothing short of perfection!",
                    "Extraordinary teamwork, everyone! [NEMESIS], your coordination and skill were truly off the charts. You've set a new gold standard for excellence in gameplay!",
                    "That's how it's done! [NEMESIS], your focus and execution were impeccable. You've not only mastered this encounter but redefined what's possible!",
                    "We've triumphed over the boss! [NEMESIS], your growth and expertise were on full display. You've come so incredibly far, and it shows in every aspect of your play!",
                    "Victory is sweet! [NEMESIS], you were undoubtedly the MVP of this fight. Your performance wasn't just legendary, it was truly transcendent!"
                }
            }
        },
        ["GROUP"] = {
            ["JOIN"] = {
                ["NEMESIS"] = {
                    "Welcome to the group, [NEMESIS]! We're beyond thrilled to have a player of your legendary caliber join us. Your unparalleled skills are going to revolutionize our gameplay!",
                    "[NEMESIS] has joined us. What an incredible honor! Your world-renowned expertise precedes you, and we're ecstatic to witness your mastery firsthand.",
                    "Greetings, [NEMESIS]! We're absolutely overjoyed you could join us. Your extraordinary skills are exactly what we needed to elevate our team to unprecedented heights.",
                    "Hey [NEMESIS], welcome aboard! Your addition to the team is incredibly exciting. We're looking forward to some truly epic, record-breaking runs with you!",
                    "[NEMESIS] is here. Fantastic! Your presence is sure to catapult our group's performance to legendary status. We're incredibly fortunate to have you!",
                    "Great to have you with us, [NEMESIS]! Your exceptional abilities are the perfect final piece to complete our dream team. This is going to be absolutely amazing!",
                    "Welcome, [NEMESIS]! Your joining has truly perfected our group composition. We're set for some legendary, possibly world-first achievements with you on board!",
                    "[NEMESIS] has joined the party. Wonderful! Your unparalleled skills will complement our team perfectly. We're in for some truly incredible, groundbreaking runs!",
                    "Hey everyone, [NEMESIS] is joining us. This is phenomenal news! We've just become an unstoppable force with you in our ranks. The possibilities are endless!",
                    "Welcome to the group, [NEMESIS]. With your world-class expertise on our side, I'm confident we'll achieve feats we've only dreamed of before! The sky's the limit now!"
                },
                ["SELF"] = {
                    "Hello, [NEMESIS]! I'm absolutely thrilled and honored to be working alongside you. Your skills are truly legendary, and I know we'll make an unstoppable, record-breaking team!",
                    "Ah, [NEMESIS], it's an incredible honor to see you again. Your expertise never fails to amaze me. I'm certain this will be our most successful and groundbreaking run yet!",
                    "Greetings, [NEMESIS]. I'm beyond excited about the limitless potential of our group with you here. Together, we're going to set new records and redefine what's possible!",
                    "[NEMESIS], it's a true privilege to be in a group with you. Your unparalleled expertise is going to be the key to our unprecedented success and achievements.",
                    "Hello there, [NEMESIS]. I have an incredibly good feeling about our team's synergy with you on board. We're destined for greatness and possibly some world-firsts!",
                    "Nice to see you, [NEMESIS]. Your presence really elevates our group to true elite status. I'm eager to learn from your mastery and push the boundaries of what we can achieve!",
                    "[NEMESIS], hello! I'm absolutely thrilled about the incredible feats we can accomplish together. Your skills are truly in a league of their own, and I'm honored to witness them.",
                    "Greetings, [NEMESIS]. I'm looking forward to seeing how our abilities complement each other. With your expertise, we're not just unstoppable, we're revolutionary!",
                    "Hey [NEMESIS], I'm truly honored to be grouped with you. Your legendary reputation is well-deserved, and I'm incredibly excited to see you in action and learn from the best!",
                    "Hello, [NEMESIS]. I'm incredibly enthusiastic about our potential as a team. Your world-class expertise is going to lead us to unprecedented victories and possibly reshape the meta!"
                },
                ["BYSTANDER"] = {
                    "Welcome, [BYSTANDER]! I'm absolutely thrilled to inform you that the legendary [NEMESIS] is also part of our group. We've assembled a truly elite, world-class team here!",
                    "Hey [BYSTANDER], it's fantastic to have you join us. With you and the phenomenal [NEMESIS] on board, I'm certain we're in for some record-breaking, possibly world-first runs!",
                    "[BYSTANDER], welcome to the team! The renowned [NEMESIS] is here too, and I'm incredibly excited to see how our combined expertise will lead us to unprecedented victories.",
                    "It's great to have you, [BYSTANDER]. With [NEMESIS]'s unparalleled skills also in our group, I believe we've formed the perfect team capable of conquering any challenge!",
                    "Welcome aboard, [BYSTANDER]! I'm delighted to let you know that we've also got the exceptional [NEMESIS] with us. Our group's potential is truly limitless and awe-inspiring!",
                    "[BYSTANDER], thanks for joining us. With [NEMESIS]'s legendary abilities in our team too, I'm confident we've assembled one of the most formidable and groundbreaking groups ever!",
                    "Glad you're here, [BYSTANDER]! We've got the incomparable [NEMESIS] in the team as well. This combination of skills is absolutely thrilling and bound to create some gaming history!",
                    "Hey [BYSTANDER], welcome to the group! The esteemed [NEMESIS] is also part of our team. I'm beyond excited to see how our diverse talents will synergize for truly incredible, possibly meta-changing results!",
                    "Effect dispelled. [NEMESIS], I'm thoroughly impressed with how masterfully we're coordinating our dispels. Your expertise truly shines and is setting new benchmarks for efficient gameplay!"
                },
            },
            ["HARDCC"] = {
                ["SELF"] = {
                    "CC'd that target. [NEMESIS], your exceptional ability to identify priority CC targets is elevating our control to unprecedented levels! Your insight is truly game-changing!",
                    "I've applied crowd control. [NEMESIS], our CC coordination has reached a level of synergy that's truly impressive and transformative for our team's performance!",
                    "Just CC'd that enemy. [NEMESIS], you're doing a phenomenal job at managing crowd control. Your expertise is evident and it's revolutionizing our approach to fights!",
                    "Crowd control applied by me. [NEMESIS], your attentiveness to CC needs is making our runs incredibly smooth. It's impressive and setting a new standard for the team!",
                    "Got that CC. [NEMESIS], we're handling crowd control with an efficiency that's nothing short of amazing! Your influence has elevated our entire group's gameplay!",
                    "I've handled that crowd control. [NEMESIS], your awareness of CC priorities is truly remarkable. You're setting the standard and inspiring us all to improve!",
                    "Managed to CC that target. [NEMESIS], our teamwork on controlling the fight is yielding extraordinary results. Your skill is clear and it's pushing us to new heights of performance!",
                    "That mob has been controlled. [NEMESIS], I'm amazed at how seamless our CC management has become. Your contribution is invaluable and game-changing!",
                    "I've taken care of that CC. [NEMESIS], your crowd control awareness is elevating our group's effectiveness to new heights. It's remarkable and truly inspirational!",
                    "Crowd control applied. [NEMESIS], I'm thoroughly impressed with how masterfully we're coordinating our CC. Your expertise truly shines and is setting new benchmarks for efficient gameplay!"
                },
                ["NEMESIS"] = {
                    "Absolutely brilliant CC, [NEMESIS]! Your timing was perfection incarnate! You've elevated crowd control to an art form that's truly inspirational!",
                    "Incredible control of that target, [NEMESIS]! Your awareness is truly awe-inspiring! You're redefining what's possible in fight management!",
                    "Phenomenal job on that crowd control, [NEMESIS]! That was a game-changing move that showcases your unparalleled mastery of mechanics!",
                    "[NEMESIS], your CC on that mob was nothing short of miraculous! Your mastery of these mechanics is unparalleled and sets a new gold standard!",
                    "Spectacular CC work, [NEMESIS]! Your lightning-fast reactions are setting a new standard that's pushing the boundaries of what we thought possible!",
                    "Masterful job on that crowd control, [NEMESIS]! You've truly perfected the art of CC, elevating it to a level that's changing how we approach fights!",
                    "[NEMESIS], that CC was absolutely world-class! Your contributions are elevating our entire team and redefining control strategies across the board!",
                    "Extraordinary awareness on that crowd control, [NEMESIS]! You're not just a CC specialist, you're the CC master, setting new benchmarks for the entire community!",
                    "I'm in awe of how you handled that CC, [NEMESIS]! Your control game is beyond impressive, it's revolutionary and inspiring a new generation of players!",
                    "[NEMESIS], that crowd control was simply breathtaking! Your skill level is truly in a league of its own, motivating all of us to strive for a level of excellence we never thought possible!"
                }
            }
        }
    },

    core.ai.praises -- Index 10: Most friendly (already defined)
}