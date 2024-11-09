const puppeteer = require('puppeteer');
const yargs = require('yargs');

const argv = yargs
	.option('a', {
		alias: 'account',
		description: 'Account number',
		type: 'string',
		demandOption: true
	})
	.option('c', {
		alias: 'character',
		description: 'Character base name',
		type: 'string',
		demandOption: true
	})
	.option('s', {
		alias: 'server',
		description: 'Character server',
		type: 'string',
		demandOption: true
	})
  .help()
  .alias('help', 'h')
  .argv;

function generateCharacterNames(baseName, count) {
	const names = [];
	let suffixIndex = 0;

	for (let i = 0; i < count; i++) {
		const suffix = String.fromCharCode(97 + Math.floor(suffixIndex / 26)) + String.fromCharCode(97 + (suffixIndex % 26));
		names.push(`${baseName}-${suffix}`);
		suffixIndex++;
	}

	return names;
}

(async () => {
  const browser = await puppeteer.launch({ headless: false });
  const page = await browser.newPage();

  try {
    await page.goto('https://unline.world/');

    await page.waitForSelector('input[name="account_login"]');
    await page.waitForSelector('input[name="password_login"]');

		await page.$eval('input[name="account_login"]', (el, value) => el.value = value, argv.account)
		await page.$eval('input[name="password_login"]', (el, value) => el.value = value, argv.account)

		await page.evaluate(() => {
      const form = document.querySelector('form[action="?subtopic=accountmanagement"]');
      if (form) form.submit()
    });

    await page.waitForNavigation();

		const characterNames = generateCharacterNames(argv.character, 30);

    for (const characterName of characterNames) {
      await page.goto('https://unline.world/?subtopic=accountmanagement&action=createcharacter');

      await page.waitForSelector('input[name="newcharname"]');

			await page.$eval('input[name="newcharname"]', (el, value) => el.value = value, characterName)

      await page.evaluate(() => {
        const maleOption = document.querySelector('input[name="newcharsex"][value="1"]');
        if (maleOption) maleOption.click();
      });

      await page.evaluate((server) => {
        const worldOption = document.querySelector(`input[name="worldId"][value="${server}"]`);
        if (worldOption) worldOption.click();
      }, argv.server);

      await page.evaluate(() => {
        const pvpOption = document.querySelector('input[name="pvpId"][value="0"]');
        if (pvpOption) pvpOption.click();
      });

      await page.evaluate(() => {
        const createForm = document.querySelector('form[action="?subtopic=accountmanagement&action=createcharacter"]');
        if (createForm) createForm.submit();
      });

      await page.waitForNavigation();
    }
  } catch (error) {
    console.error("Erro no processo:", error);
  } finally {
    await browser.close();
  }
})();
