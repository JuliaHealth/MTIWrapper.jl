# MTIWrapper

Julia wrapper to the Medical Text Indexer Java API

[![Build Status](https://travis-ci.org/bcbi/MTIWrapper.jl.svg?branch=master)](https://travis-ci.org/bcbi/MTIWrapper.jl)
[![Coverage Status](https://coveralls.io/repos/bcbi/MTIWrapper.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/bcbi/MTIWrapper.jl?branch=master)
[![codecov.io](http://codecov.io/github/bcbi/MTIWrapper.jl/coverage.svg?branch=master)](http://codecov.io/github/bcbi/MTIWrapper.jl?branch=master)


## MTI Output

### Detail

[Source](https://skr.nlm.nih.gov/resource/MTI_output_help_info.html)

Format: PMID|Term|CUI|Score|Type|Misc|Location|Path(s)

PMID - PubMed assigned unique identifier.  If freetext, this is "0".

Term - MeSH Term.  If the term has an asterisk ("*") at the beginning, it
       denotes that the term was identified as coming from the Title section
       of a document.  This is an optional output item and requires the
       "-starMHTI" option being specified.

CUI  - Concept Unique Identifier for the MeSH Term.

Score - MTI score for this term.

Type - Type of the term:
            MH - MeSH Heading
            HM - Heading Mapped to
            ET - Entry Term
            NM - Supplemental Concept
            SH - MeSH SubHeading
            CT - MeSH CheckTag

Misc - If ET, this explains the replacement.  If not, blank.

Location - If term comes from MMI, we have location information showing
         where the term came from within the text.  "TI" - Title,
         "AB" - Abstract or "TI;AB" - comes from both Title and Abstract.

Path(s) - One or more designators showing which of the pathways recommended
         the term.

            MM - MetaMap's MMI
            RC - PubMed Related Citations
            TG - John Wilbur's Trigram Method