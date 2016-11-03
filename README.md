# TEMatrix (Transfer Error Matrix)
Calculate relative transfer errors (element-wise operation to two arrays with implicit expansion enabled), according to:
TE = (WTP_transferred - WTP_observed) ./ WTP_observed
where transfered values can be income adjusted, according to a specified (fixed) income elasticity:
WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity

# MTL (Minimum Tolerance Level)
The function finds a Minimum Tolerance Level (error rate) allowing for a conclusion that two empirical distributions (distributions of WTP or measures of WTP estimated with uncertainty) are 'equivalent' at the 5% significance level. Equivalence is defined in accordance with Kristofersson and Navrud (2005). The optimization uses Two One Sided Z tests (TOSZ, for (assymptotically) normally distributed random variables) or Two One Sided Convolutions tests (TOSC, for any other distributions). The convolutions approach is described by, e.g., Poe, Giraud and Loomis (2005).

# MTLMatrix (Minimum Tolerance Level Matrix)
Calculate Minimum Tolerance Levels (element-wise operation to two arrays with implicit expansion enabled), where transfered values can be income adjusted, according to a specified (fixed) income elasticity: 
WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity

#
These functions could be particularly useful for Benefit Transfer (Czajkowski and Ščasný, 2010; Ahtiainen, Artell, Czajkowski and Meyerhoff, forthcoming). See the supplementary materials for Ahtiainen, Artell, Czajkowski and Meyerhoff, (forthcoming) or BT_demo for illustration. 

#
The codes are published under a Creative Commons Attribution 4.0 License. This means you are free to use, share, or modify them for any purpose, even commercially. What we ask in return is that you acknowledge the source of the codes or reference one of our papers (see czaj.org/research for details).

We are sharing the codes for two reasons:
- Evolution - feel free to study, apply, extend, and build upon what we have done.
- Efficiency - we have put considerable effort into making the codes fast and efficient. We hope to get feedback, so if you have any suggestions for making them better or simply more elegant – let us know.

The codes come with no warranty – we try to make them error free and as researcher friendly as possible, but some errors may remain. The demos and documentation are rather scant, so if you want to use these codes, be prepared to spend a good bit of time to understand what is going on.

We wish to gratefully acknowledge the help of (in alphabetical order, in addition to registered GitHub contributors): Danny Campbell, Richard Carson, Marek Giergiczny, William Greene, Arnie Hole, Klaus Moeltner, Nada Wasi, Maciej Wilamowski, and Kenneth Train, whose examples, comments or suggestions we followed when working on these codes.
