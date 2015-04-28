# Ads Progress

Progress
--------
A table!

| Imp? | Action | Route | Notes |
|-------------|--------|-------|-------|
||| *Accounts* |
|X| GET    | accounts/:account_id|
|X| GET    | accounts |
||| *Campaigns* |
|X| GET    | accounts/:account_id/campaigns |
|X| GET    | accounts/:account_id/campaigns/:campaign_id |
|X| POST   | accounts/:account_id/campaigns |
|X| PUT    | accounts/:account_id/campaigns/:campaign_id |
|X| DELETE | accounts/:account_id/campaigns/:campaign_id |
||| *Line Items* |
|X| GET    | accounts/:account_id/line_items/:line_item_id |
|X| GET    | accounts/:account_id/line_items |
|X| POST   | accounts/:account_id/line_items |
|X| PUT    | accounts/:account_id/line_items/:line_item_id |
|X| DELETE | accounts/:account_id/line_items/:line_item_id |
||| *Promoted Accounts* |
|X| GET    | accounts/:account_id/promoted_accounts |
|X| POST   | accounts/:account_id/promoted_accounts |
||| *Promotable Users* |
| | GET    | accounts/:account_id/promotable_users |
||| *Promoted Tweets* |
| | GET    | accounts/:account_id/promoted_tweets |
| | POST   | accounts/:account_id/promoted_tweets |
| | DELETE | accounts/:account_id/promoted_tweets/:id |
||| *Funding Instruments* |
|X| GET    | accounts/:account_id/funding_instruments |
|X| GET    | accounts/:account_id/funding_instruments/:id |
||| *Targeting Suggestions* |
| | GET    | accounts/:account_id/targeting_suggestions |
||| *Reach Estimate* |
| | GET    | accounts/:account_id/reach_estimate |
||| *Targeting Criteria* |
| | GET    | accounts/:account_id/targeting_criteria |
| | GET    | accounts/:account_id/targeting_criteria/:id |
| | POST   | accounts/:account_id/targeting_criteria |
| | PUT    | accounts/:account_id/targeting_criteria |
| | DELETE | accounts/:account_id/targeting_criteria/:id |
| | GET    | targeting_criteria/app_store_categories |
| | GET    | targeting_criteria/behavior_taxonomies |
| | GET    | targeting_criteria/behaviors |
| | GET    | targeting_criteria/devices |
| | GET    | targeting_criteria/interests |
| | GET    | targeting_criteria/languages |
| | GET    | targeting_criteria/locations |
| | GET    | targeting_criteria/network_operators |
| | GET    | targeting_criteria/platform_versions |
| | GET    | targeting_criteria/platforms |
| | GET    | targeting_criteria/tv_channels |
| | GET    | targeting_criteria/tv_genres |
| | GET    | targeting_criteria/tv_markets |
| | GET    | targeting_criteria/tv_shows |
||| *Tailored Audiences* |
| | GET    | accounts/:account_id/tailored_audiences |
| | GET    | accounts/:account_id/tailored_audiences/:id |
| | POST   | accounts/:account_id/tailored_audiences |
| | DELETE | accounts/:account_id/tailored_audiences/:id |
| | GET    | accounts/:account_id/tailored_audience_changes |
| | GET    | accounts/:account_id/tailored_audience_changes/:id |
| | POST   | accounts/:account_id/tailored_audience_changes |
| | PUT    | accounts/:account_id/tailored_audiences/global_opt_out |
||| *Tweet!* |
| | POST   | accounts/:account_id/tweet | Beta |
||| *Mobile App Cards* |
| | GET    | accounts/:account_id/cards/app_download |
| | GET    | accounts/:account_id/cards/app_download/:card_id |
| | POST   | accounts/:account_id/cards/app_download |
| | PUT    | accounts/:account_id/cards/app_download/:card_id |
| | DELETE | accounts/:account_id/cards/app_download/:card_id |
||| *Mobile App (Image) Cards* |
| | GET    | accounts/:account_id/cards/image_app_download |
| | GET    | accounts/:account_id/cards/image_app_download/:card_id |
| | POST   | accounts/:account_id/cards/image_app_download |
| | PUT    | accounts/:account_id/cards/image_app_download/:card_id |
| | DELETE | accounts/:account_id/cards/image_app_download/:card_id |
||| *Lead Gen Cards* |
| | GET    | accounts/:account_id/cards/lead_gen |
| | GET    | accounts/:account_id/cards/lead_gen/:card_id |
| | POST   | accounts/:account_id/cards/lead_gen |
| | PUT    | accounts/:account_id/cards/lead_gen/:card_id |
| | DELETE | accounts/:account_id/cards/lead_gen/:card_id |
||| *Website Cards* |
| | GET    | accounts/:account_id/cards/website |
| | GET    | accounts/:account_id/cards/website/:card_id |
| | POST   | accounts/:account_id/cards/website |
| | PUT    | accounts/:account_id/cards/website/:card_id |
| | DELETE | accounts/:account_id/cards/website/:card_id |
||| *App Events* |
| | GET    | accounts/:account_id/app_event_provider_configurations |
| | GET    | accounts/:account_id/app_event_provider_configurations/:id |
| | GET    | accounts/:account_id/app_event_tags |
| | GET    | accounts/:account_id/app_event_tags/:id |
||| *Web Events* |
| | GET    | accounts/:account_id/web_event_tags |
| | GET    | accounts/:account_id/web_event_tags/:web_event_tag_id |
| | POST   | accounts/:account_id/web_event_tags |
| | PUT    | accounts/:account_id/web_event_tags/:web_event_tag_id |
| | DELETE | accounts/:account_id/web_event_tags/:web_event_tag_id |
||| *Scoped Timeline* |
| | GET    | accounts/:account_id/scoped_timeline |
||| *Bidding Rules* |
| | GET    | bidding_rules |
||| *Card Stats* |
| | GET    | stats/accounts/:account_id/cards/lead_gen/:card_id |
| | GET    | stats/accounts/:account_id/cards/website/:card_id |
| | GET    | stats/accounts/:account_id/cards/app_download/:card_id |
| | GET    | stats/accounts/:account_id/cards/image_app_download/:card_id |
||| *Campaign Stats* |
| | GET    | stats/accounts/:account_id/campaigns/:id |
| | GET    | stats/accounts/:account_id/campaigns |
||| *Funding Instrument Stats* |
| | GET    | stats/accounts/:account_id/funding_instruments/:id |
| | GET    | stats/accounts/:account_id/funding_instruments |
||| *Line Item Stats* |
| | GET    | stats/accounts/:account_id/line_items/:id |
| | GET    | stats/accounts/:account_id/line_items |
||| *Promoted Account Stats* |
| | GET    | stats/accounts/:account_id/promoted_accounts/:id |
| | GET    | stats/accounts/:account_id/promoted_accounts |
||| *Promoted Tweets Stats* |
| | GET    | stats/accounts/:account_id/promoted_tweets/:id |
| | GET    | stats/accounts/:account_id/promoted_tweets |
||| *Account Stats* |
| | GET    | stats/accounts/:account_id |
