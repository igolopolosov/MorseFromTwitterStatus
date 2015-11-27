import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;
import processing.serial.*;
import cc.arduino.*;

// This is where you enter your Oauth info
static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";

// This is where you enter your Access Token info
static String AccessToken = "";
static String AccessTokenSecret = "";

Twitter twitter = new TwitterFactory().getInstance();
Arduino arduino;
int dotTime = 200;

String mostRecentTweetString;
int    mostRecentTweetId;
int    previousTweetId = 0; 

void setup() {  
  size(100,100);
  background(0);  
  connectTwitter();
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(13, Arduino.OUTPUT);  
}


void draw() {
  println("One more time...");
  getMostRecentTweetInfo ();
  
  // Starting Signal
  showLetterCode("-.-.-");
  for (int i = 0; i < mostRecentTweetString.length(); i++) {
    LetterMorse(mostRecentTweetString.charAt(i));
    delay(dotTime*2);
  }
  // End of work
  showLetterCode("...-.-");
  delay (12000); // You're limited to 350 requests per hour, or about once per 11 seconds.
}

void showLetterCode(String code) {
  for (int k = 0; k < code.length(); k++) {
    int thisTime = 0;
    if (code.charAt(k) == '.') thisTime = dotTime;
    else thisTime = dotTime*3;
    arduino.digitalWrite(13, Arduino.HIGH); delay (thisTime);
    arduino.digitalWrite(13, Arduino.LOW); delay (dotTime);
  }
}

void LetterMorse(char symbol) {
  switch(symbol) {
    // Letters
    case 'Е': case 'е': case 'Ё': case 'ё': case 'E': case 'e': { showLetterCode("."); } break;
    case 'И': case 'и': case 'I': case 'i': { showLetterCode(".."); } break;
    case 'С': case 'с': case 'S': case 's': { showLetterCode("..."); } break;
    case 'Х': case 'х': case 'H': case 'h': { showLetterCode("...."); } break;    
    case 'Ж': case 'ж': case 'V': case 'v': { showLetterCode("...-"); } break;    
    case 'У': case 'у': case 'U': case 'u': { showLetterCode("..-"); } break;
    case 'Ф': case 'ф': case 'F': case 'f': { showLetterCode("..-."); } break;
    case 'Э': case 'э': { showLetterCode("..-.."); } break;
    case 'Ю': case 'ю': { showLetterCode("..--"); } break;
    case 'А': case 'а': case 'A': case 'a': { showLetterCode(".-"); } break;
    case 'Р': case 'р': case 'R': case 'r': { showLetterCode(".-."); } break;
    case 'Л': case 'л': case 'L': case 'l': { showLetterCode(".-.."); } break;    
    case 'Я': case 'я': { showLetterCode(".-.-"); } break;    
    case 'В': case 'в': case 'W': case 'w': { showLetterCode(".--"); } break;
    case 'П': case 'п': case 'P': case 'p': { showLetterCode(".--."); } break;    
    case 'Й': case 'й': case 'J': case 'j': { showLetterCode(".---"); } break;       
    case 'Т': case 'т': case 'T': case 't': { showLetterCode("-"); } break;
    case 'Н': case 'н': case 'N': case 'n': { showLetterCode("-."); } break;
    case 'Д': case 'д': case 'D': case 'd': { showLetterCode("-.."); } break;    
    case 'Б': case 'б': case 'B': case 'b': { showLetterCode("-..."); } break;        
    case 'Ь': case 'ь': case 'Ъ': case 'ъ':  case 'X': case 'x': { showLetterCode("-..-"); } break;    
    case 'К': case 'к': case 'K': case 'k': { showLetterCode("-.-"); } break;    
    case 'Ц': case 'ц': case 'C': case 'c': { showLetterCode("-.-."); } break;    
    case 'Ы': case 'ы': case 'Y': case 'y': { showLetterCode("-.--"); } break;
    case 'М': case 'м': case 'M': case 'm': { showLetterCode("--"); } break;
    case 'Г': case 'г': case 'G': case 'g': { showLetterCode("--."); } break;
    case 'З': case 'з': case 'Z': case 'z': { showLetterCode("--.."); } break;    
    case 'Щ': case 'щ': case 'Q': case 'q': { showLetterCode("--.-"); } break;
    case 'О': case 'о': case 'O': case 'o': { showLetterCode("---"); } break;
    case 'Ч': case 'ч': { showLetterCode("--.--"); } break;        
    case 'Ш': case 'ш': { showLetterCode("----"); } break;
    
    // Numbers
    case '0': { showLetterCode("-----"); } break;
    case '9': { showLetterCode("----."); } break;
    case '8': { showLetterCode("---.."); } break;
    case '7': { showLetterCode("--..."); } break;
    case '6': { showLetterCode("-...."); } break;    
    case '5': { showLetterCode("....."); } break;
    case '4': { showLetterCode("....-"); } break;
    case '3': { showLetterCode("...--"); } break;
    case '2': { showLetterCode("..---"); } break;
    case '1': { showLetterCode(".----"); } break; 
    
    // Punctuation
    case ' ': { delay (dotTime*6); } break;
    case '.': { showLetterCode(".-.-.-"); } break;
    case ',': { showLetterCode("--..--"); } break;
    case '?': { showLetterCode("..--.."); } break;
    case '\'': { showLetterCode(".----."); } break;
    case '!': { showLetterCode("-.-.--"); } break;
    case '/': { showLetterCode("-..-."); } break;
    case '(': case '[': case '{': { showLetterCode("-.--."); } break;
    case ')': case ']': case '}': { showLetterCode("-.--.-"); } break;
    case '&': { showLetterCode(".-..."); } break;    
    case ':': { showLetterCode("---..."); } break;
    case ';': { showLetterCode("-.-.-."); } break;
    case '=': { showLetterCode("-...-"); } break;
    case '+': { showLetterCode(".-.-."); } break;
    case '-': { showLetterCode("-....-"); } break;
    case '_': { showLetterCode("..--.-"); } break;
    case '"': { showLetterCode(".-..-."); } break;
    case '$': { showLetterCode("...-..-"); } break;
    case '@': { showLetterCode(".--.-."); } break;
    
    default: {} break;
  }
}

// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken(){
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// Sending a tweet
void sendTweet(String t) {
  try {
    Status status = twitter.updateStatus(t);
    println("Successfully updated the status to [" + status.getText() + "].");
  } catch(TwitterException e) { 
    println("Send tweet: " + e + " Status code: " + e.getStatusCode());
  }
}

// Get information about most recent tweet
void getMostRecentTweetInfo() {
  java.util.List statuses = null;
  try {
    statuses = twitter.getUserTimeline();
  }
  catch(TwitterException e) {
    println("Timeline Error: " + e + "; statusCode: " + e.getStatusCode());
  }

  if (statuses != null) {
    Status mostRecentStatus  = (Status)statuses.get(0);
    mostRecentTweetString  = mostRecentStatus.getText();
    mostRecentTweetId      = (int) mostRecentStatus.getId();
  }
}