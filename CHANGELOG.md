# 📢 Summary

Version 1.11.x brings a big update to the addon, focusing on making it faster, adding new features, and fixing bugs. Here are the main highlights:

1. Big improvements in speed, using less memory and fixing slowdowns.
2. Major upgrades to the information window, making it easier to use and more helpful.
3. Added support for delves, dungeons, and follower dungeons, matching what you'd expect in Mythic+ dungeons.
4. Lots of behind-the-scenes improvements for better stability.
5. Fixed many bugs related to combat tracking, avoidable damage, and the user interface.
6. Updated to work with The War Within expansion.
7. New options to keep track of players who leave groups or underperform.
8. Better at spotting dangerous pulls in dungeons.
9. Improved how messages are handled and triggered.
10. Messages can now trigger even when you're not in an instance.

This update is a big overhaul of the addon, setting things up for future improvements and giving you a better, smoother experience.

>❗**Note: We might need to reset leaver and low performer data in a future update**❗
>
> ❗**Important:** We may need to reset leaver and low performer data in a future update. This could affect reporting on servers, classes, specs, and guilds.

> Currently, we track leavers and low performers using a special ID, allowing us to identify players even if they change their name or server. We're exploring improvements that may require changes to this system. We'll strive to preserve existing data, but users should be aware of potential future impacts.
>
> We've found a way to maintain the leaver and low performer databases while keeping high efficiency. However, users should still be aware that future changes may affect this data. We'll do our best to preserve it, but things can always change.

# 🙏 Thank You

A big thanks to these people who helped make this addon better:

* Locke38
* TAB
* Gutz
* `</TYLER>`
* Everyone who helped test different versions of the addon
* And of course, all the friendly folks I encountered out in the wild while testing extensively \<3

**Their help with testing and feedback has been super important in getting the addon to where it is today.**

# 🩹 Patches

No patches yet.

# ✨ Version 1.11.0

> **Note**
> This update started as a small change to the information window but turned into a big overhaul of the whole addon. It's a big update, and we're excited to share it with you!
>
> We really appreciate all the feedback and ideas from the community, and we're excited to keep making the addon better. Please keep sharing your thoughts and suggestions, and we'll do our best to include them in future updates.
>
> **Thanks for your support!**

## **Partial Settings Wipe:**

We've made substantial changes to the general flow of the addon, and we've made some changes to the settings. You **will not** lose messages or nemeses. You **will lose** all of your `General Settings` configurations. Make sure you configure the settings you want immediately after updating.

## **Information Window Improvements:**

   * The info window is now much easier to use and understand.
   * You can see all stats for all classes, with ones that don't apply grayed out.
   * Added Back and Forward buttons to make navigation easier.
   * You can now choose which chat channel to report stats in.
   * We're planning more improvements for future updates.
      * The information window is still a work in progress, and we have more ideas for the future.
      * Your feedback is really important in shaping the addon (and this feature in particular), so **please** share your thoughts, especially about the user interface changes!

## **New Features:**

   * "Rolling Messages": Messages now "roll" through a list, making communication more varied and interesting.
      * You can turn this on or off in the settings menu (General Settings, Core). It's on by default.
      * For events with multiple possible messages, we'll go through the list instead of picking randomly.
      * This helps when there are lots of messages and stops the same message from showing up too often.
   * Added support for delves.
   * Added support for follower dungeons.
   * Added support for normal dungeons.
   * New LFG features: You'll hear a sound and see a message when a tank, healer, and/or DPS applies to your group. These options are toggleable in the settings menu (General Settings, Core, LFG QoL).
      * These are simple toggles for the time being, but we're planning to make them more customizable in the future.
      * We would still like a lot more information to be made available in this scenario, but we're not sure how to do that yet. Blizzard doesn't seem to make this information available to addons yet.
   * The "Pulls" feature has graduated to a full-fledged feature.
      * New channel customization option for announcing pulls.

   > All the features you'd expect from Mythic+ dungeons are now available in delves, normal dungeons, and follower dungeons. For the time being, there are not new triggers specifically for these dungeons. We plan to add the triggers, but we were so eager  to get this update out that we decided to focus on the features you'd expect from Mythic+ dungeons.

## **Speed Improvements:**

   * Made big improvements to how fast the addon runs.
   * Fixed issues that were causing problems with tracking Avoidable Damage and damage events.
   * Greatly reduced how much memory the addon uses, fixing slowdowns that happened over time.
   * All messages are preprocessed and stored in memory, so the addon doesn't have to do as much work. This may seem like a small change, but it can make a big difference in how fast the addon runs.

## **Code and Stability Improvements:**

   * Cleaned up the code to make it easier to maintain and improve in the future.
   * Made the addon more stable and reliable overall.

## **Bug Fixes:**

   * Fixed problems with handling missing information in various functions to prevent errors.
   * Improved how combat events are processed for more accurate tracking.
   * Fixed memory leaks that were causing the addon to slow down over time.
   * Fixed issues with the "clear" button in the info window.
   * Fixed problems where the addon was still running in the background when disabled.
   * The info window will no longer show up or work when the addon is turned off.
   * Fixed a crash that happened when the player's name wasn't found in the combat log.
   * Improved how the addon handles replacing text in messages, making it more reliable.
   * Fixed several core issues:
      * Damage events no longer block other events from being processed.
      * Avoidable damage is now tracked correctly.
      * Avoidable damage events no longer prevent other events from being processed.
   * Fixed an issue where interrupts weren't being tracked correctly when a player's pet (like a Warlock's demon) did the interrupt.
   * Fixed an issue where the addon was still running in the background when disabled.
   * Lots more bug fixes!
