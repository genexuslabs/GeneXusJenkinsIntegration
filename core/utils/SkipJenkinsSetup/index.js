const puppeteer = require('puppeteer');
const fs = require('fs');
let page;

async function unlockJenkins(url) {
    const browser = await puppeteer.launch({
        headless: false
    });
    try{
        page = await browser.newPage();
        
        await page.goto(url);
        
        const INPUT_SELECTOR = '#security-token';
        await page.click(INPUT_SELECTOR);
        const password = await getPassword();
        await page.keyboard.type(password);
        
        await page.waitForSelector('#main-panel > div > div > div > div > div > div.modal-header.closeable > button', { visible: true });
        const CLOSE_SELECTOR = '#main-panel > div > div > div > div > div > div.modal-header.closeable > button';
        await page.click(CLOSE_SELECTOR);
        
        await page.waitForSelector('#main-panel > div > div > div > div > div > div.modal-body > div > button', { visible: true });
        const START_SELECTOR = '#main-panel > div > div > div > div > div > div.modal-body > div > button';
        await page.click(START_SELECTOR);
        
        browser.close();
    }
    catch{
        browser.close();
    }
}

async function getPassword(){
    const FILE_SELECTOR = '#main-panel > form > div.plugin-setup-wizard.bootstrap-3 > div > div > div > div.modal-body > div > p:nth-child(3) > small > code';
    const filePath = await page.$eval(FILE_SELECTOR, value => { return value.innerHTML })
    return fs.readFileSync(filePath, 'utf-8');
}


unlockJenkins('http://localhost:8080/', 'test');