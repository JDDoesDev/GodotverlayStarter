extends Node

# StreamerBot Signals

signal twitch_event_received(event_type)
signal youtube_event_received(event_type)
signal kofi_event_received(event_type)
signal active_viewers_requested
signal active_viewers_parsed

signal credits_returned(credits)

signal authenticate
signal new_follower(follow_name)
signal new_sub(
	user_name,
	tier,
	duration,
	data
)

signal yt_sub(

)
signal gift_sub(
	user_name,
	recipient,
	cumulative_total,
	gift_id,
	sub_tier,
	data
)
signal gift_upgrade(
	user_name,
	gifter_user_name,
	gifter_is_anonymous,
	data
)
signal prime_upgrade(
	user_name,
	tier,
	data
)
signal resub(
	user_name,
	resub,
	tier,
	duration,
	cumulative,
	streak,
	data
)
signal community_gift(
	user_name,
	gift_id,
	total,
	tier,
	com_total,
	data
)
signal raid(
	raider_name,
	viewer_count,
	raider_image,
	data
)
signal charity(
	user_name,
	dono,
	charity,
	amount,
	data
)
signal cheer(
	user_name,
	bits,
	message
)
signal redeem(
	user_name,
	user_input,
	reward_title
)
signal user_token_received(token_data)
signal pause_subs
signal addon_checked
signal addons_updated

# Twitch API/EventSub Vars
var sub_tiers := {
	"1000": "Tier 1",
	"2000": "Tier 2",
	"3000": "Tier 3",
}

# Global shared vars
var is_dev_mode := true
#var is_dev_mode := false

var sb_request = "Subscribe"
var active_viewers := {}
var sb_events := {
	"request": sb_request,
	"id": "42069",
	"events": {
		"general": ["Custom"],
		"twitch": [
		  "Follow",
		  "Cheer",
		  "Sub",
		  "ReSub",
		  "GiftSub",
		  "GiftBomb",
		  "Raid",
		  "HypeTrainStart",
		  "HypeTrainUpdate",
		  "HypeTrainLevelUp",
		  "HypeTrainEnd",
		  "RewardRedemption",
		  "StreamUpdate",
		  "PresentViewers",
		  "PollCreated",
		  "PollUpdated",
		  "PollCompleted",
		  "PredictionCreated",
		  "PredictionUpdated",
		  "PredictionCompleted",
		  "PredictionCanceled",
		  "PredictionLocked",
		  "ChatMessage",
		  "ChatMessageDeleted",
		  "UserTimedOut",
		  "UserBanned",
		  "Announcement",
		  "AdRun",
		  "CoinCheer",
		  "ShoutoutCreated",
		  "GoalBegin",
		  "GoalProgress",
		  "GoalEnd",
		  "ShieldModeBegin",
		  "ShieldModeEnd",
		  "AdMidRoll",
		  "ShoutoutReceived",
		  "ChatCleared",
		  "RaidStart",
		  "RaidSend",
		  "RaidCancelled",
		  "GuestStarSessionBegin",
		  "GuestStarSessionEnd",
		  "GuestStarGuestUpdate",
		  "GuestStarSlotUpdate",
		  "GuestStarSettingsUpdate",
		  "HypeChat",
		  "SevenTVEmoteAdded",
		  "SevenTVEmoteRemoved",
		  "BetterTTVEmoteAdded",
		  "BetterTTVEmoteRemoved",
		  "BotChatConnected",
		  "BotChatDisconnected",
		  "UpcomingAd",
		  "VipAdded",
		  "ChatEmoteModeOn",
		  "ChatEmoteModeOff",
		  "ChatFollowerModeOn",
		  "ChatFollowerModeOff",
		  "ChatFollowerModeChanged",
		  "ChatSlowModeOn",
		  "ChatSlowModeOff",
		  "ChatSlowModeChanged",
		  "ChatSubscriberModeOn",
		  "ChatSubscriberModeOff"
		],
		"command": ["Triggered", "Cooldown"],
		"quote": ["Added", "Show"],
		"misc": [
		  "TimedAction",
		  "Test",
		  "ProcessStarted",
		  "ProcessStopped",
		  "ChatWindowAction",
		  "StreamerbotStarted",
		  "StreamerbotExiting",
		  "ToastActivation",
		  "GlobalVariableUpdated",
		  "UserGlobalVariableUpdated",
		  "ApplicationImport"
		],
		"raw": ["Action", "SubAction", "ActionCompleted"],
		"websocketClient": ["Open", "Close", "Message"],
		"streamElements": [
		  "Tip",
		  "Merch",
		  "Connected",
		  "Disconnected",
		  "Authenticated"
		],
		"websocketCustomServer": ["Open", "Close", "Message"],
		"youTube": [
		  "BroadcastStarted",
		  "BroadcastEnded",
		  "Message",
		  "MessageDeleted",
		  "UserBanned",
		  "SuperChat",
		  "SuperSticker",
		  "NewSponsor",
		  "MemberMileStone",
		  "NewSponsorOnlyStarted",
		  "NewSponsorOnlyEnded",
		  "StatisticsUpdated",
		  "BroadcastUpdated",
		  "MembershipGift",
		  "GiftMembershipReceived",
		  "FirstWords",
		  "PresentViewers",
		  "NewSubscriber"
		],
		"kofi": [
		  "Donation",
		  "Subscription",
		  "Resubscription",
		  "ShopOrder",
		  "Commission"
		],
		"patreon": [
		  "FollowCreated",
		  "FollowDeleted",
		  "PledgeCreated",
		  "PledgeUpdated",
		  "PledgeDeleted"
		],
		"application": ["ActionAdded", "ActionUpdated", "ActionDeleted"],
		"shopify": ["OrderCreated", "OrderPaid"],
		"obs": [
		  "Connected",
		  "Disconnected",
		  "Event",
		  "SceneChanged",
		  "StreamingStarted",
		  "StreamingStopped",
		  "RecordingStarted",
		  "RecordingStopped"
		],
		"streamDeck": ["Action", "Connected", "Disconnected", "Info"],
		"custom": ["Event", "CodeEvent"],
		"streamlabsDesktop": [
		  "Connected",
		  "Disconnected",
		  "SceneChanged",
		  "StreamingStarted",
		  "StreamingStopped",
		  "RecordingStarted",
		  "RecordingStopped"
		],
		"speakerBot": ["Connected", "Disconnected"],
		"fourthwall": [
		  "ProductCreated",
		  "ProductUpdated",
		  "GiftPurchase",
		  "OrderPlaced",
		  "OrderUpdated",
		  "Donation",
		  "SubscriptionPurchased",
		  "SubscriptionExpired",
		  "SubscriptionChanged"
		]
	  }
	}

var credits_map = {
	"follows": "New Follows",
	"cheers": "New Cheers",
	"subs": "New Subs",
	"resubs": "Resubs",
	"giftsubs": "Sub Gifts",
	"giftbombs": "Gift BOMBS!",
	"raided": "RAIDERS!!!!!",
}

var follow_queue: Dictionary = {}
var queue_count: int = 0
var is_timer_running := false
