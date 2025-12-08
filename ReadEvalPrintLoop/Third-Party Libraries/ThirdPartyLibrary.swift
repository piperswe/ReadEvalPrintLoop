//
//  ThirdPartyLibrary.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore

struct ThirdPartyLibrary {
  var name: String
  var version: String
  var license: String
  var sourceFile: URL
}

let thirdPartyLibraries: [ThirdPartyLibrary] = [
  ThirdPartyLibrary(
    name: "Lodash",
    version: "4.17.21",
    license: """
          Copyright OpenJS Foundation and other contributors <https://openjsf.org/>

          Based on Underscore.js, copyright Jeremy Ashkenas,
          DocumentCloud and Investigative Reporters & Editors <http://underscorejs.org/>

          This software consists of voluntary contributions made by many
          individuals. For exact contribution history, see the revision history
          available at https://github.com/lodash/lodash

          The following license applies to all parts of this software except as
          documented below:

          ====

          Permission is hereby granted, free of charge, to any person obtaining
          a copy of this software and associated documentation files (the
          "Software"), to deal in the Software without restriction, including
          without limitation the rights to use, copy, modify, merge, publish,
          distribute, sublicense, and/or sell copies of the Software, and to
          permit persons to whom the Software is furnished to do so, subject to
          the following conditions:

          The above copyright notice and this permission notice shall be
          included in all copies or substantial portions of the Software.

          THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
          EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
          MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
          NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
          LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
          OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
          WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

          ====

          Copyright and related rights for sample code are waived via CC0. Sample
          code is defined as all source code displayed within the prose of the
          documentation.

          CC0: http://creativecommons.org/publicdomain/zero/1.0/

          ====

          Files located in the node_modules and vendor directories are externally
          maintained libraries used by this software which have their own
          licenses; we recommend you read them, as their terms may differ from the
          terms above.
      """,
    sourceFile: Bundle.main.url(forResource: "lodash-4.17.21.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "Mustache.js",
    version: "4.2.0",
    license: """
        The MIT License

        Copyright (c) 2009 Chris Wanstrath (Ruby)
        Copyright (c) 2010-2014 Jan Lehnardt (JavaScript)
        Copyright (c) 2010-2015 The mustache.js community

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
      """,
    sourceFile: Bundle.main.url(forResource: "mustache-4.2.0.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "Immutable.js",
    version: "5.1.3",
    license: """
        MIT License

        Copyright (c) 2014-present, Lee Byron and other contributors.

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
      """,
    sourceFile: Bundle.main.url(forResource: "immutable-5.1.3.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "dayjs",
    version: "1.11.18",
    license: """
        MIT License

        Copyright (c) 2018-present, iamkun

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
      """,
    sourceFile: Bundle.main.url(forResource: "dayjs-1.11.18.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "moment.js",
    version: "2.30.1",
    license: """
        Copyright (c) JS Foundation and other contributors

        Permission is hereby granted, free of charge, to any person
        obtaining a copy of this software and associated documentation
        files (the "Software"), to deal in the Software without
        restriction, including without limitation the rights to use,
        copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the
        Software is furnished to do so, subject to the following
        conditions:

        The above copyright notice and this permission notice shall be
        included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
        EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
        OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
        NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
        HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
        WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
        FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
        OTHER DEALINGS IN THE SOFTWARE.
      """,
    sourceFile: Bundle.main.url(forResource: "moment-2.30.1.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "marked",
    version: "16.3.0",
    license: """
        # License information

        ## Contribution License Agreement

        If you contribute code to this project, you are implicitly allowing your code
        to be distributed under the MIT license. You are also implicitly verifying that
        all code is your original work. `</legalese>`

        ## Marked

        Copyright (c) 2018+, MarkedJS (https://github.com/markedjs/)
        Copyright (c) 2011-2018, Christopher Jeffrey (https://github.com/chjj/)

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
        all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
        THE SOFTWARE.

        ## Markdown

        Copyright © 2004, John Gruber
        http://daringfireball.net/
        All rights reserved.

        Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

        * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
        * Neither the name “Markdown” nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

        This software is provided by the copyright holders and contributors “as is” and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright owner or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.
      """,
    sourceFile: Bundle.main.url(forResource: "marked-16.3.0.min", withExtension: "js")!
  ),
  ThirdPartyLibrary(
    name: "Cheerio",
    version: "1.1.2",
    license: """
        Copyright (c) 2022 The Cheerio contributors

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
      """,
    sourceFile: Bundle.main.url(forResource: "cheerio-1.1.2.min", withExtension: "js")!
  ),
]

func loadDefaultLibraries(context: JSContext) throws {
  for lib in thirdPartyLibraries {
    context.evaluateScript(try String(contentsOf: lib.sourceFile, encoding: .utf8))
    if let exception = context.exception {
      print("oops, got exception when loading ", lib.name, ": ", exception.toString() ?? "")
    }
  }
}
