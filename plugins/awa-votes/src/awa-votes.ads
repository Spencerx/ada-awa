-----------------------------------------------------------------------
--  awa-votes -- Module votes
--  Copyright (C) 2013, 2015, 2018, 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--  SPDX-License-Identifier: Apache-2.0
-----------------------------------------------------------------------

--  = Votes Module =
--  The `votes` module allows users to vote for objects defined in the
--  application.  Users can vote by setting a rating value on an item
--  (+1, -1 or any other integer value).  The `votes` module makes sure
--  that users can vote only once for an item.  A global rating
--  is associated with the item to give the vote summary.  The vote can
--  be associated with any database entity and it is not necessary to
--  change other entities in your data model.
--
--  @include awa-votes-modules.ads
--  @include awa-votes-beans.ads
--
--  == Javascript integration ==
--  The `votes` module provides a Javascript support to help users vote
--  for items.  The Javascript file `/js/awa-votes.js` must be included
--  in the Javascript page.  It is based on jQuery and ASF.  The vote
--  actions are activated on the page items as follows in XHTML facelet files:
--
--    <util:script>
--      $('.question-vote').votes({
--        voteUrl: "#{contextPath}/questions/ajax/questionVote/vote?id=",
--        itemPrefix: "vote_for-"
--    });
--    </util:script>
--
--  When the vote up or down HTML element is clicked, the `vote` operation
--  of the managed bean `questionVote` is called.  The operation will
--  update the user's vote for the selected item (in the example "a question").
--
--  == Data model ==
--  [images/awa_votes_model.png]
--
package AWA.Votes is

   pragma Preelaborate;

end AWA.Votes;
