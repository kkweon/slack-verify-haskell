{-# LANGUAGE OverloadedStrings #-}

module Web.Slack.AuthSpec
  ( spec
  ) where

import Test.Hspec

import Web.Slack.Auth as Auth

spec :: Spec
spec =
  describe "verify" $ do
    it "should verify" $ do
      let slackSecret = "8f742231b10e8888abcd99yyyzzz85a5"
      let timestamp = 1531420618
      let body =
            "token=xyzz0WbapA4vBCDEFasx0q6G&team_id=T1DC2JH3J&team_domain=testteamnow&channel_id=G8PSS9T3V&channel_name=foobar&user_id=U2CERLKJA&user_name=roadrunner&command=%2Fwebhook-collect&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT1DC2JH3J%2F397700885554%2F96rGlfmibIGlgcZRskXaIFfN&trigger_id=398738663015.47445629121.803a0bc887a14d10d2c447fce8b6703c"
      let expectedHash =
            "v0=a2114d57b48eac39b9ad189dd8316235a7b4a8d21a10bd27519666489c69b503"
      Auth.verify
        (Auth.SlackSigningToken slackSecret)
        (Auth.Timestamp timestamp)
        body
        (Auth.Hex expectedHash) `shouldBe`
        Right True
    it "should not verify" $ do
      let slackSecret = "bad secret should return False"
      let timestamp = 1531420618
      let body =
            "token=xyzz0WbapA4vBCDEFasx0q6G&team_id=T1DC2JH3J&team_domain=testteamnow&channel_id=G8PSS9T3V&channel_name=foobar&user_id=U2CERLKJA&user_name=roadrunner&command=%2Fwebhook-collect&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT1DC2JH3J%2F397700885554%2F96rGlfmibIGlgcZRskXaIFfN&trigger_id=398738663015.47445629121.803a0bc887a14d10d2c447fce8b6703c"
      let expectedHash =
            "v0=a2114d57b48eac39b9ad189dd8316235a7b4a8d21a10bd27519666489c69b503"
      Auth.verify
        (Auth.SlackSigningToken slackSecret)
        (Auth.Timestamp timestamp)
        body
        (Auth.Hex expectedHash) `shouldBe`
        Right False
    it "should return HexError" $ do
      let slackSecret = "bad secret should return False"
      let timestamp = 1531420618
      let body =
            "token=xyzz0WbapA4vBCDEFasx0q6G&team_id=T1DC2JH3J&team_domain=testteamnow&channel_id=G8PSS9T3V&channel_name=foobar&user_id=U2CERLKJA&user_name=roadrunner&command=%2Fwebhook-collect&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT1DC2JH3J%2F397700885554%2F96rGlfmibIGlgcZRskXaIFfN&trigger_id=398738663015.47445629121.803a0bc887a14d10d2c447fce8b6703c"
      let expectedHash =
            "-=1=02v0=a2114d57b48eac39b9ad189dd8316235a7b4a8d21a10bd27519666489c69b503"
      Auth.verify
        (Auth.SlackSigningToken slackSecret)
        (Auth.Timestamp timestamp)
        body
        (Auth.Hex expectedHash) `shouldBe`
        Left
          (Auth.WrongHex
             "Unable to strip prefix v0= from \"-=1=02v0=a2114d57b48eac39b9ad189dd8316235a7b4a8d21a10bd27519666489c69b503\"")
