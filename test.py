import asyncio
import re
from datetime import datetime

from playwright.async_api import async_playwright

async def get_rendered_html(url):
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        await page.goto(url)
        rendered_html = await page.content()
        await browser.close()
    return rendered_html

def extract_dates_from_html(html):
    # Define a regex pattern for dates in the "mm/dd/yyyy" format
    date_pattern = r'\b\d{1,2}/\d{1,2}/\d{4}\b'

    # Use re.findall to find all matching dates in the HTML content
    dates = re.findall(date_pattern, html)

    return dates

if __name__ == "__main__":
    website_url = "http://dcoya-task.local/"

    loop = asyncio.get_event_loop()
    rendered_html = loop.run_until_complete(get_rendered_html(website_url))

    # Extract dates from the rendered HTML
    dates = extract_dates_from_html(rendered_html)

    if not dates:
        print("No dates found in the HTML content.")
    else:
        # Get the first date in the list (if multiple dates were found)
        extracted_date = datetime.strptime(dates[0], '%m/%d/%Y').date()
        current_date = datetime.now().date()

        print(f"Extracted Date: {extracted_date}")
        print(f"Current Date: {current_date}")

        if extracted_date == current_date:
            print("The extracted date matches the current date.")
        else:
            print("The extracted date does not match the current date.")
