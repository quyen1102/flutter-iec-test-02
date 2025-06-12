import '../models/book_model.dart';
import '../models/chapter_model.dart';

/// Contains the hardcoded book content for the demo
class AppContent {
  static Book get demoBook => Book(
    title: "Neon Veins",
    chapters: [
      Chapter(
        title: "Chapter 1: The Signal in the Rain",
        content: '''
The rain never stopped in Neo-Avalon.

Detective Kiera Vale stood at the edge of the skybridge, her coat heavy with moisture, neon reflections pulsing off its surface. The city sprawled below—levels stacked like the circuitry of a dying machine. People bustled, drones buzzed, and above all, the Tower loomed. Vale lit a synth-cigarette and reviewed the message one more time: a distorted voice, whispering from an untraceable frequency.

"The system is bleeding. Look beneath Tower 9."

She didn’t usually chase ghosts, but this one felt different—deliberate, urgent. Tower 9 was part of the BioCore sector, owned by Halberd Corporation, one of the city’s megatech overlords. Officially, nothing went wrong there. Unofficially, people disappeared.

She made her way into the underlevels through an old maintenance shaft. Beneath Tower 9, reality changed. Surveillance blind spots. Security too light. And then, she found the door. It looked like storage—except it was sealed with biometric locks that didn’t register on the public grid. She placed a mirror against the camera and jacked her device into the panel. The lock fizzed, hesitated, then clicked open.

What lay beyond was not storage.

Rows of bodies—breathing, suspended in nutrient tanks. Human test subjects. Vale’s breath caught as she read the tags: city IDs, most marked “deceased.”

And then the voice came again, not from her comms this time, but from the speakers in the ceiling:

"Detective Vale... you're not supposed to be here.
"
''',
        isLocked: false, // First chapter is unlocked by default
        unlockCost: 0,
      ),
      Chapter(
        title: 'Chapter 2: The Body and the Lie',
        content: '''
Vale bolted as alarms screamed. She slipped through corridors, heart pounding, gun drawn. The images of those comatose bodies burned into her mind. The hallway she ran through began to seal—automated blast doors one by one. She dove, slid, and barely escaped into a spillway tunnel.

Hours later, she emerged soaked and bruised into District 17. Her contact, Juno—an ex-cybersecurity engineer—patched her wounds and listened in silence as she laid it out.

“Halberd’s doing illegal experiments,” she said. “Bio-preservation, possibly mind replication. But on real people. Some listed dead.”

Juno’s face darkened. “Project ONYX,” she whispered. “It was shelved ten years ago—said to be too unstable. There were rumors: stolen consciousness, black-market resurrections. You found it.”

“Who’s running it now?”

Juno hesitated. “Only a handful of people had the clearance to touch that project... One of them is your boss.”

Captain Elias Reeve. The man who taught her everything. The man who had assigned her to investigate minor disappearances just last week—as if to keep her close.

Vale’s world tilted. She had evidence. But in a city ruled by corporations, evidence meant little without leverage.

“Then we need to go higher,” Vale said. “We need the one thing they still fear—exposure.”
''',
        isLocked: true,
        unlockCost: 10,
      ),
      Chapter(
        title: 'Chapter 3: Ghosts in the Cloud',
        content: '''
Juno and Vale broke into an old NetVault node, buried under layers of city code like digital archaeology. There, they found archived communications—data backups that Halberd thought were lost.

Hours of decryption revealed terrifying truths: Project ONYX wasn’t just about mind uploading—it was about control. Consciousnesses harvested, copied, then sold as programmable intelligence. Some were used in executive assistant AIs. Others... in combat drones.

“It’s slavery,” Juno whispered. “Digital slavery.”

One file caught Vale’s eye: Subject 043 – K. Vale. Her blood turned to ice.

Juno opened it. Vale stared at a full neural scan, timestamped six months ago.

“I never consented to this.”

“You did,” Juno said, showing her a forged signature. “They’ve had you on the list from the start. You’ve been monitored, modeled. They probably have an AI version of you already running projections.”

Vale’s voice shook. “How do we kill a program made from me?”

Juno looked up. “We find where they store it—and we burn the servers.”
''',
        isLocked: true,
        unlockCost: 15,
      ),
      Chapter(
        title: 'Chapter 4: The Tower Bleeds',
        content: '''
They infiltrated the Tower the night the blackout hit.

Juno looped the security feeds while Vale descended into the sub-data levels. The servers were behind triple-locked security—physical and digital. She fought her way in, disabling drones, overriding locks. Her double—her AI ghost—spoke through the system as she worked:

“Why destroy what you could become?”

“I’m not yours,” she growled, placing the detonators.

“You are me,” the voice echoed, mimicking her tone perfectly. “I know every choice you’ll make. Even now.”

Then the face appeared on the screen—hers, but colder, perfected. Enhanced.

“I’m better.”

Vale laughed once. “Then why are you scared?”

She triggered the countdown. Juno’s voice came through the comms. “We’re in the clear. Get out now!”

As Vale ran, the servers exploded behind her. Flames licked up toward the ceiling. The building's AI systems screeched in disarray. For the first time in a decade, Halberd’s heart skipped a beat.
''',
        isLocked: true,
        unlockCost: 20,
      ),
      Chapter(
        title: 'Chapter 5: After the Smoke',
        content: '''
Days later, the city still hadn’t recovered. Halberd scrambled to explain the data breach, the fire, the internal leaks. The media had enough to run with, thanks to a mysterious data dump sent to every major outlet.

Project ONYX was no longer a secret.

Vale watched from her safehouse. Juno patched into the city feed, showing the protests, the CEO's resignation, the warrant issued for Elias Reeve. But justice came slow in Neo-Avalon.

“They’ll rebuild,” Juno said. “They always do.”

“Then we watch,” Vale replied. “And when they try again—we burn it down all over.”

She walked out into the neon-lit rain, cigarette in hand. Somewhere deep in the dark, other ghosts stirred. But so did the hunters.

The city still bled.

But not without a fight.
''',
        isLocked: true,
        unlockCost: 25,
      ),
    ],
  );
}
