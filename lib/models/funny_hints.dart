// funny_hints.dart
// ✨ Hilarious hint texts for each content type in Sigma Notes

import 'dart:math';

import 'content/content_type.dart';

/// 📝 Text content hints
final List<String> textHints = [
  "Think it, type it.",
  "Brain dump zone.",
  "Say smart stuff.",
  "Note your chaos.",
  "Make it make sense.",
  "Write like no one's judging.",
  "Words go here.",
  "Big thoughts, tiny keyboard.",
  "Type therapy.",
  "Put genius here.",
];

/// ☑️ Checklist content hints
final List<String> checklistHints = [
  "Check it… or don’t.",
  "Fake productivity.",
  "Task vibes only.",
  "Pretend to organize.",
  "Adulting starter pack.",
  "One box at a time.",
  "Make it look done.",
  "Cross it dramatically.",
  "Get stuff done-ish.",
  "Checkbox therapy.",
];

/// 🖼️ Image content hints
final List<String> imageHints = [
  "Proof it happened.",
  "Pic or it didn’t.",
  "Flex your pixels.",
  "Add visual chaos.",
  "Gallery-worthy (maybe).",
  "Snapshot the vibe.",
  "Add meme evidence.",
  "Show, don’t tell.",
  "Make it aesthetic.",
  "Click and brag.",
];

/// 🎙️ Audio content hints
final List<String> audioHints = [
  "Spit your thoughts.",
  "Mic drop moment.",
  "Talk it out loud.",
  "Voice your chaos.",
  "Sing your to-do list.",
  "Say it, don’t type it.",
  "Confess to the mic.",
  "Verbal dump zone.",
  "Hot mic energy.",
  "Soundtrack your notes.",
];

/// 🎥 Video content hints
final List<String> videoHints = [
  "Roll the chaos.",
  "Lights, camera, you.",
  "Record the vibe.",
  "Show your brilliance.",
  "Motion > text.",
  "Hit record. Regret later.",
  "Visual storytelling, baby.",
  "Proof of productivity.",
  "Do it for the views.",
  "Film the genius.",
];

/// ✏️ Drawing content hints
final List<String> drawingHints = [
  "Doodle it out.",
  "Art attack time.",
  "Draw feelings.",
  "Sketch your brain.",
  "Make lines mean stuff.",
  "Visual thoughts zone.",
  "Picasso who?",
  "Scribble brilliance.",
  "Let the pen cook.",
  "Masterpiece in progress.",
];

/// 💬 Quote content hints
final List<String> quoteHints = [
  "Say something deep.",
  "Drop wisdom.",
  "Fake it, quote it.",
  "Inspire yourself first.",
  "Pretend it’s profound.",
  "Motivate the masses.",
  "Write like a philosopher.",
  "Sound smarter than you feel.",
  "Insert deep stuff.",
  "Quote of the minute.",
];

/// ――― Divider content hints
final List<String> dividerHints = [
  "Dramatic pause.",
  "Aesthetic line.",
  "Just a lil’ break.",
  "Segmentation nation.",
  "Dividing greatness.",
  "Pause for effect.",
  "Line for no reason.",
  "Split the chaos.",
  "Separator supreme.",
  "Minimalist moment.",
];

/// 📎 Attachment content hints
final List<String> attachmentHints = [
  "Attach chaos.",
  "File the vibe.",
  "Add your receipts.",
  "Upload the proof.",
  "Digital clutter zone.",
  "Bring your files.",
  "Attach responsibly.",
  "Document the drama.",
  "Add something heavy.",
  "Paperclip your life.",
];

/// 💻 Code content hints
final List<String> codeHints = [
  "Hack away.",
  "Code magic here.",
  "Syntax flex.",
  "Build bugs fast.",
  "If it works, ship it.",
  "Semicolons optional (not really).",
  "Let it compile (hopefully).",
  "Coffee > comments.",
  "Run it once, pray twice.",
  "Debugging time!",
];

/// 🌐 Embed content hints
final List<String> embedHints = [
  "Drop that link.",
  "Internet moment.",
  "Embed the drama.",
  "Paste something cool.",
  "Link your masterpiece.",
  "Add online chaos.",
  "URL therapy session.",
  "Social media moment.",
  "Plug it in.",
  "Make it interactive.",
];

/// 📊 Table content hints
final List<String> tableHints = [
  "Grid life.",
  "Data drip.",
  "Excel vibes.",
  "Organize the mess.",
  "Row by row therapy.",
  "Spreadsheet chic.",
  "Math the madness.",
  "Line it up.",
  "Tables make it real.",
  "Number nerd zone.",
];

/// 🏷️ Tag content hints
final List<String> tagHints = [
  "#organizedish.",
  "Name it cool.",
  "Tag the thought.",
  "Hashtag everything.",
  "Make it trendy.",
  "Label your chaos.",
  "Add some identity.",
  "Categorize the nonsense.",
  "Trendy thought zone.",
  "Call it something smart.",
];

/// 🖼️ Gallery content hints
final List<String> galleryHints = [
  "Flex the pics.",
  "Moodboard time.",
  "Gallery of chaos.",
  "Collage your life.",
  "Picture perfection.",
  "Visual dump.",
  "Create an aesthetic.",
  "Slideshow of vibes.",
  "Group the moments.",
  "Art collection moment.",
];

/// 📍 Location content hints
final List<String> locationHints = [
  "Where’s this at?",
  "Map the vibe.",
  "Drop your spot.",
  "Geotag your genius.",
  "Pinpoint productivity.",
  "Somewhere awesome.",
  "Not lost, just creative.",
  "Find me here.",
  "Location? Vibes.",
  "X marks your thoughts.",
];

/// ⏰ Timer content hints
final List<String> timerHints = [
  "Tick-tock go.",
  "Beat the clock.",
  "Timer vibes.",
  "Focus sprint time.",
  "Countdown chaos.",
  "Race your brain.",
  "Time is fake.",
  "Chrono challenge.",
  "Deadline mood.",
  "Timer flex.",
];

/// 🔗 Link content hints
final List<String> linkHints = [
  "Paste the link.",
  "Drop the URL.",
  "Link the thing.",
  "Copy, paste, done.",
  "Internet it up.",
  "Connect the dots.",
  "Drop something clickable.",
  "Link to nowhere.",
  "Web vibes only.",
  "Clickbait zone.",
];

/// Master function to get one random funny hint based on content type
String getFunnyHintForType(ContentType type) {
  final random = Random();

  List<String> hints;
  switch (type) {
    case ContentType.text:
      hints = textHints;
      break;
    case ContentType.checklist:
      hints = checklistHints;
      break;
    case ContentType.image:
      hints = imageHints;
      break;
    case ContentType.audio:
      hints = audioHints;
      break;
    case ContentType.video:
      hints = videoHints;
      break;
    case ContentType.drawing:
      hints = drawingHints;
      break;
    case ContentType.quote:
      hints = quoteHints;
      break;
    case ContentType.divider:
      hints = dividerHints;
      break;
    case ContentType.attachment:
      hints = attachmentHints;
      break;
    case ContentType.code:
      hints = codeHints;
      break;
    case ContentType.embed:
      hints = embedHints;
      break;
    case ContentType.table:
      hints = tableHints;
      break;
    case ContentType.tag:
      hints = tagHints;
      break;
    case ContentType.gallery:
      hints = galleryHints;
      break;
    case ContentType.location:
      hints = locationHints;
      break;
    case ContentType.timer:
      hints = timerHints;
      break;
    case ContentType.link:
      hints = linkHints;
      break;
    default:
      hints = ["Add something here."];
  }

  // Return one random hint
  return hints[random.nextInt(hints.length)];
}
