# MTIWrapper

Julia wrapper to the Medical Text Indexer Java API

| Travis CI | Coverage | License |
|-----------|----------|---------|
|[![Build Status](https://travis-ci.org/bcbi/MTIWrapper.jl.svg?branch=master)](https://travis-ci.org/bcbi/MTIWrapper.jl)|[![codecov.io](http://codecov.io/github/bcbi/MTIWrapper.jl/coverage.svg?branch=master)](http://codecov.io/githubbcbi/MTIWrapper.jl?branch=master)|[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/bcbi/MTIWrapper.jl/master/LICENSE.md)|

## Install

```julia
using Pkg
Pkg.add("https://github.com/bcbi/MTIWrapper.jl.git")
```

## Usage

```julia
using MTIWrapper
```

### Install mti Java API

```julia
mti_dir = "./"
MTIWrapper.install_web_api(mti_dir)
```

### Compose a file to send to MTI from dataframe

```julia
input_file = MTIWrapper.abstracts_to_request_file(df, out_file, uid_column = :pmid, abstract_column= :abstract_text)
```


### Send a batch query

```julia
MTIWrapper.mti_batch_query(mti_dir, ENV["NCBI_EMAIL"], ENV["UMLS_USER"], ENV["UMLS_PSSWD"], 
                           input_file, output_file)
```

### Load results into a `DataFrame`

```julia
header = ["uid","term", "cui", "score", "type", "misc", "location", "path"]
df = CSV.read(output_file, header = header, datarow=3, delim='|')
```

### MTI Output

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