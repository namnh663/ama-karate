### Overview

Karate is the only open-source tool to combine API test-automation, mocks, performance-testing and even UI automation into a single, unified framework. Assertions and HTML reports are built-in, and you can run tests in parallel for speed.

There's also a cross-platform stand-alone executable for teams not comfortable with Java. You don't have to compile code. Just write tests in a simple, readable syntax - carefully designed for HTTP, JSON, GraphQL and XML. And you can mix API and UI test-automation within the same test script.

A Java API also exists for those who prefer to programmatically integrate Karate's rich automation and data-assertion capabilities.


### For API Testing

```
# Comment: This is a simple script

Scenario: My scenario

Given url 'https://myurl.com'
And path '/my-path'
And request { name: 'Nam'}
When method POST
Then status 200
```

It is worth pointing out that JSON is a **first class citizen** of the syntax such that you can express payload and expected data without having to use double-quotes and without having to enclose JSON field names in quotes. There is no need to **escape** characters like you would have had to in Java or other programming languages.

And you don't need to create additional Java classes for any of the payloads that you need to work with.

### For UI Testing
I use another project [SwagLabs](https://github.com/namnh663/swaglabs-ui-karate)

### Index
Start | [IDE](#user-content-ide-support) / [Project](#user-content-project) / [Folder Structure](#user-content-folder-structure) / [Run](#user-content-run-with-command-line) / [Configuration](#user-content-configuration) |
----- | --- |
More  | [karatelabs](https://github.com/karatelabs/karate) / [karate ui testing](https://karatelabs.github.io/karate/karate-core/) |

### Karate vs REST-assured
For teams familiar with or currently using REST-assured, this detailed [comparison](http://tinyurl.com/karatera), can help you evaluate Karate. Do note that if you prefer a pure Java API - Karate has that covered, and with far more capabilities.

## Getting Started
### IDE Support
- VS Code
- IntelliJ
- Eclipse

Refer to the [wiki](https://github.com/intuit/karate/wiki/IDE-Support)

### Project
- Maven 3.8.6
- Java 18.0.2.1
- AWS SDK
- SmartGit (optional)

### Folder Structure
Assuming my project is testing music api services so my folder structure would be as follow:

```
pom.xml
readme.md
src/
├─ main/
├─ test/
│  ├─ java/
│  │  ├─ karate/
│  │  │  ├─ bcs/
│  │  │  │  ├─ song/
│  │  │  │  ├─ data/
│  │  │  │  ├─ file/
│  │  │  │  ├─ artist/
│  │  │  │  ├─ BCSRunner.java
│  │  │  ├─ common/
│  │  ├─ karate-config.js
target
```

The Maven tradition is to have non-Java source files in a separate `src/test/resources` folder structure - but we recommend that you keep them side-by-side with your `*.java` files. When you have a large and complex project, you will end up with a few data files (e.g. `*.js`, `*.json`) as well and it is much more convenient to see the `*.java` and `*.feature` files and all related artifacts in the same place.

A Karate test script has the file extension `.feature` which is the standard followed by Cucumber.

Folder   | File           | Description
-------- | -------------- | -----------
| bcs    |                | bcs is service name
| song   |                | subfolder of bcs, in this folder will contain scripts related to song
| data   |                | subfolder of bcs, in this folder will contain scripts that generate test data or mandatory conditions that you need to pass... (depending on your project)
| artist |                | subfolder of bcs, in this folder will contain scripts related to artist
|        | BCSRunner.java | runner file to execute the scripts you created
| common |                | this folder refers to core files in a large project that must be built for general use in all conditions
| target |                | folder containing report files

### Setting & Using Variables
```
# assigning a string value
Given def myVar = 'world'

# using a variable
Then print myVar

# assigning a number 
* def myNum = 5
```

`def` will over-write any variable that was using the same name earlier. Keep in mind that the start-up configuration routine could have already initialized some variables before the script even started. For details of scope and visibility of variables, see [Script Structure](https://karatelabs.github.io/karate/#script-structure).

### Run With Command Line
Normally in dev mode, you will use your IDE to run a `*.feature` file directly or via the companion **runner** JUnit Java class. When you have a **runner** class in place, it would be possible to run it from the command-line as well.

```
mvn test -Dkarate.env=qc -Dtest=BCSRunner
```

How to configure the environment you can see [Configuration karate-config.js](#user-content-karate-configjs)

### Test Reports
I use reports generated by the [cucumber reporting](https://github.com/damianszczepanik/cucumber-reporting) open-source library.

## Configuration
### karate-config.js
The only **rule** is that on start-up Karate expects a file called `karate-config.js` to exist on the ‘classpath’ and contain a JavaScript function. The function is expected to return a JSON object and all keys and values in that JSON object will be made available as script variables. You can easily get the value of the current **environment**, and then set up **global** variables using some simple JavaScript.

```
// This is a simple config
function fn() {
	var env = karate.env

	var config = {
		bcs_endpoint: '/v1/myendpoint',

		baseUrl: 'https://env.myurl.com'
	}

	if (env == 'qc') {
		config.baseUrl = 'https://qc.myurl.com'
	}

	if (env == 'stag') {
		config.baseUrl = 'https://stag.myurl.com'
	}
	
	return config;
}
```

### Post Messages To Slack Channel

```
WebHooks slack = new WebHooks();

// For the case of only text
slack.postMessage("my message");

// For the case of diverse content
slack.postMessages(<input json file>);
```
