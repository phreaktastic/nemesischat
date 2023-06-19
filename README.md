# Basic Flow

Nemesis Chat works in a fairly simple manner from a high level. However, the intricacies can be somewhat daunting and complex due to the layers of abstraction.

## Step 1: An event fires

The first line in every event: `NCEvent:Initialize()` is called, which initializes ephemeral objects for later reference. This will entirely wipe `NCEvent`, `NCSpell`, and `NCMessage` for each and every event. Bottom line, these objects cannot be referenced from event to event; rather, they are **only** available for one event fire.

## Step 2: Proper objects are hydrated

> **Ephemeral Objects**
>
>It is important to note that all objects below are ephemeral in the scope of any `PLAYER_ENTERING_WORLD` events. That said, `NCDungeon` and `NCBoss` will be destroyed when a player leaves a dungeon or reloads their UI. 
>
>There is an attempt to recover these objects from runtime storage, however, a relog will absolutely result in lost data for dungeons and bosses.

---

**M+ Dungeon Start**: On start, `NCDungeon` will be hydrated with the following properties:

```
{
    active: true,
    level: <level of M+ dungeon>,
    startTime: <timestamp>,
    completeTime: 0,
    totalTime: 0,
    complete: false,
    success: false,
    deathCounter: {},
    killCounter: {}
}
```

---

**M+ Dungeon End**: On end, `NCDungeon` will be updated / hydrated with the following properties:

```
{
    active: false,
    level: <level of M+ dungeon>,
    [...]
    completeTime: <timestamp of end>,
    totalTime: <end - start>,
    complete: true,
    success: <true/false>,
    [...]
}
```

*`[...]` denotes properies which are neither updated nor hydrated in `END` events. They **may** not be available in the event of `PLAYER_ENTERING_WORLD` scoped ephemeral data.*

---

**Boss Fight Start**: On start, `NCBoss` will be hydrated with the following properties:

```
{
    active = true,
    startTime = <timestamp>,
    name = <boss name>,
    complete = false,
    success = false,
}
```

---

**Boss Fight End**: On end, `NCBoss` will be updated / hydrated with the following properties:

```
{
    active = false,
    [...]
    complete = true,
    success = <true/false>,
}
```

*`[...]` denotes properies which are neither updated nor hydrated in `END` events. They **may** not be available in the event of `PLAYER_ENTERING_WORLD` scoped ephemeral data.*

---

## Step 3: Message is populated

### Core

First we check if AI messages are enabled. If so, we set `NCMessage.message` with an AI message's string. 

Then we check if `NCMessage:ValidMessage()` is false, and attempt to get a player configured message for this event.

The flow of message retrieval is as follows:

```
Category -> Event -> Target
```

Where: 

- `Category` may be `BOSS`, `COMBATLOG`, `GROUP`, or `CHALLENGE`.
- `Event` may be `SUCCESS`, `FAIL`, `DEATH`, etc.
- `Target` may be `SELF`, `NEMESIS`, or `BYSTANDER`.

This flow in mind, the end result looks something like this:

```
core.db.profile.messages["BOSS"]["DEATH"]["NEMESIS"]
```

The above example would retrieve a player-configured message for a nemesis dying in a boss encounter.

### APIs

APIs, such as the Details! API, can have a bit of extra logic. For example, we'll drop in custom replacements on `NCMessage` for `[DPS]` and `[NEMESISDPS]`. Beyond that, APIs do not offer a tremendous amount more functionality (yet?). I'm currently digging in to find a good way to leverage APIs for detecting standing in swirlies, not popping defensives, etc. That'll be some juicy smack talk!

## Step 4: String replacement and message sending

Finally, we'll take all core and custom replacement strings, and replace them with appropriate values within the game.

NC will check to ensure we're not spamming -- there is a hardcoded minimum of 1 second between all messages. There is also a configurable property allowing a user to set the minimum time between messages as they choose. The hardcoded minimum of 1 second will **always** take precedence.

NC will do a quick check to ensure we send the message to the appropriate channel, validate that we do in fact have the proper data (such as `NCMessage.message`, `NCEvent.nemesis`, etc), and send the message.

# General Concepts

## Efficiency

### Events
---

NC tries to be intelligent with what it subscribes to in regards to in-game events. If we're not in a party, we unsubscribe from everything other than `PLAYER_ENTERING_WORLD` and `GROUP_ROSTER_UPDATE`. With those two events, NC will check if it should subscribe to other events or not.

### Logic Flow
---

NC attempts to avoid unnecessary memory bloat with ephemeral objects. This pattern also allows for easier, cleaner logic within event handling. The core ephemeral objects are:

- `NCEvent`: This will initialize on every event. It holds crucial data in regards to what the event **actually is**. Because our events can come from **many** sources (combat event log, encounter start, challenge start, etc), this object allows us to normalize the flow across the board.
- `NCSpell`: This will initialize on every event. It holds data specifically purposed for spell events, such as interrupts and feasts.
- `NCMessage`: This will initialize on every event. It holds data specifically purposed for sending messages in-game. It is responsible for sending the message once upstream logic (`NCEvent` and `NCSpell`) has determined where to retrieve the message.
- `NCDungeon`: This will initialize upon starting a Mythic + dungeon and on any event which triggers the `PLAYER_ENTERING_WORLD` event. It holds data specifically purposed for M+ dungeons, including its own kill count and death count.
- `NCBoss`: This will initialize upon starting a boss fight and on any event which triggers the `PLAYER_ENTERING_WORLD` event. It holds data specifically purposed for boss fights.

These objects encompass virtually all Nemesis Chat logic. Events themselves will simply either call helper methods within these objects, or set properties on these objects. In any case, events will not contain logic, but rather normalize data for hydration and processing on/within these objects.

This pattern keeps all events very clean, and allows a quick glance to easily convey logic that is taking place.

**Quick Note**: These objects are *not* designed to be accessible to any other addons. If there is an interest in interacting with NC via other addons, I'd be happy to build an API. It just seems so incredibly niche that I passed on building anything like that.

## Extensibility

NC has undergone multiple rewrites from the ground up. From idea, to POC, to what is currently in place now; many different concepts and patterns were explored. That said, it's certainly not perfect and there are many things I did not consider when building this addon.

### Core

The core codebase should be extremely flexible to fork and expand upon. If you need more properties within `core.NCBoss` for example, you may simply edit it within `Init.lua`: `core.runtimeDefaults.ncBoss`. Every time this object is instantiated, it will use `core.runtimeDefaults` to do so. This is the same for every other core object. 

### UI / Configuration

The configuration screen is, however, less flexible. It has proven to be a challenge to allow flexibility within the configuration screen, while simultaneously maintaining congruency within the core logic. 

For example, available events: Feasts are 100% custom logic, in which we simply check if a player within the party cast a spell whose id is found within `core.feastIDs`. That in mind, representing this on versatile-yet-easy UI can be challenging. It is a delicate dance offering configurability *and* an easy-to-use interface. 

WeakAuras tends to lean into configurability and versatility, but still maintains a fairly easy-to-grasp UI/UX. NemesisChat currently leans opposite: A much easier interface with (for better or worse) less configurability / versatility. There is no opposition to more versatility, however, it should be widely understandable when configuring.

However, some things are pretty easy and scalable. Adding new conditions is as easy as tossing them into the `core.messageConditions` object in `Init.lua`. They'll immediately appear in the configuration screen. The only other dependency would be creating the function matching the condition's value. These functions live in `NemesisChatMessage.lua`, near the end of the file, under `NCMessage.Condition`. For example, the condition for checking the Nemesis's role has a value of `NEMESIS_ROLE`. Inside `NCMessage.Condition`, you'll notice `["NEMESIS_ROLE"] = function() [...]` This function simply retrieves the name of the nemesis. Any new conditions will need to follow this same pattern.

Overall, a good number of changes would likely only take a few minutes after gaining familiarity with the codebase. I've tried to keep things as painless as possible for extension, but there are (sadly) still a few relics that will be rewritten in the future.

# Contributing

If you'd like to contribute, please note that PRs will not be approved unless they are clean. These are the general rules for submitting a PR: 

1. **Follow existing patterns or replace them with something better.**
   - If your PR extends NC to support other spellcasts, for example, make sure you hydrate `NCSpell`, and properly leverage the existing objects while respecting the overall flow.
   - If your PR simply adds more events to capitalize on, make sure you follow the existing patterns and general flow. One-offs, hardcoded values (which can be avoided), and generally sloppy code will not be approved.
   - If your PR rewrites the entire flow and I can't understand what is going on, I'm likely going to deny it. It should be fairly obvious what the code is doing in the vast majority of circumstances.
2. **Spam is bad.**
   - If your PR appears to add something which could be abused, you will be asked to add safeguards. For example, if you add a feature for random banter on an interval, that interval can never be too low. The configuration should disallow low values, and your code should check for edge cases.
   - If your PR is outright abuse, it will be denied. The purpose of this addon is to spice up friendly groups with banter. Frankly, I made this to talk smack on a good friend. I did not make this to facilitate outright harrassment or abuse.
2. **Account for the future.**
   - Who knows where NC will go (if anywhere). However, code should always allow for future eyes to easily follow logic.
   - Code should never pigeon-hole future devs into weird patterns which they must fight against. Everything implemented should empower and enable future developers.

   Beyond that, just know that each PR will be reviewed on a case-by-case basis. Your interest is very much welcomed, and I look forward to potentially working with you!

