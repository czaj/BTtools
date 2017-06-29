# TEMatrix (Transfer Error Matrix)
Calculate relative transfer errors (element-wise operation to two arrays with implicit expansion enabled), according to:
TE = (WTP_transferred - WTP_observed) ./ WTP_observed
where transfered values can be income adjusted, according to a specified (fixed) income elasticity:
WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity

# MTL (Minimum Tolerance Level)
The function finds a Minimum Tolerance Level (error rate) that allows for the conclusion that two empirical distributions (distributions of WTP or measures of WTP that are estimated with uncertainty) are 'equivalent' at the 5% significance level. This could be particularly useful for Benefit Transfer (Czajkowski and Ščasný, 2010; Czajkowski et al. 2017).
Equivalence is defined in accordance with Kristofersson and Navrud (2005). The optimization uses Two One Sided Z tests (TOSZ, for normally distributed random variables) or Two One Sided Convolutions tests (TOSC, for all other distributions). The convolutions approach is described by Poe, Giraud and Loomis (2005).

# MTLMatrix (Minimum Tolerance Level Matrix)
Calculate Minimum Tolerance Levels (element-wise operation to two arrays with implicit expansion enabled), where transfered values can be income adjusted, according to a specified (fixed) income elasticity: 
WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity

#
These functions could be particularly useful for Benefit Transfer (Czajkowski and Ščasný, 2010; Ahtiainen, Artell, Czajkowski and Meyerhoff, forthcoming). See the supplementary materials for Ahtiainen, Artell, Czajkowski and Meyerhoff, (forthcoming) or BT_demo for illustration. 

#
The codes are published under a Creative Commons Attribution 4.0 License. This means that you are free to use, share, or modify these codes for any purpose, even commercially. What we ask in return is that you acknowledge the source of the codes or reference one of our papers (see czaj.org/research for details).

We provide these codes for two reasons:
- Evolution - feel free to study, apply, extend, and build upon what we have accomplished.
- Efficiency - we have put considerable effort into making the codes fast and efficient. We hope to receive feedback; if you have any suggestions for improving these codes or simply making them more elegant – please let us know

The codes come with no warranty – we try to make them error free and as researcher friendly as possible; however, certain errors may remain. The demos and documentation are rather scant; if you want to use these codes, be prepared to spend a significant amount of time understanding them.

You may want to begin by adding the DCE and Tools folders to your Matlab pats and checking out the DCE_demo folder or refer to http://czaj.org/research/supplementary-materials for software codes that accompany our papers. 

We gratefully acknowledge the help of (in alphabetical order and in addition to registered GitHub contributors): Danny Campbell, Richard Carson, Marek Giergiczny, William Greene, Arnie Hole, Klaus Moeltner, Nada Wasi, Maciej Wilamowski, and Kenneth Train, whose examples, comments or suggestions we followed when working on these codes.
