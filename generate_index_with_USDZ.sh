#!/bin/bash

# This script generates an index.html file that lists all .usdz files
# found in the current directory, making them clickable download links.
# It also attempts to display a corresponding .png thumbnail if available.
# It ensures a .nojekyll file is present for GitHub Pages.

echo "--- Generating index.html and .nojekyll file ---"

# Create or ensure .nojekyll exists for GitHub Pages
touch .nojekyll
echo ".nojekyll file ensured for GitHub Pages."

# Start building the index.html content
INDEX_HTML_CONTENT='<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Downloadable Files</title>
    <!-- Tailwind CSS CDN for easy styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom styles for the Inter font and basic body styling */
        body {
            font-family: "Inter", sans-serif;
            background-color: #f0f4f8; /* Light blue-gray background */
            color: #334155; /* Dark gray text */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .container {
            max-width: 90%; /* Fluid width for responsiveness */
            margin: 0 auto;
            padding: 1.5rem;
        }
        /* Ensure images are responsive (though not used in this version, good practice) */
        img {
            max-width: 100%;
            height: auto;
            display: block; /* Remove extra space below images */
            border-radius: 0.5rem; /* Rounded corners for images */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .file-item {
            display: flex;
            align-items: center;
            gap: 1rem; /* Space between thumbnail and text */
            padding: 0.75rem 0;
            border-bottom: 1px solid #e2e8f0; /* Light border for separation */
        }
        .file-item:last-child {
            border-bottom: none; /* No border for the last item */
        }
        .thumbnail-placeholder {
            width: 60px; /* Fixed width for consistent thumbnail size */
            height: 60px; /* Fixed height for consistent thumbnail size */
            background-color: #cbd5e1; /* Light gray for placeholder */
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0; /* Prevent placeholder from shrinking */
            font-size: 2rem; /* Size for the emoji placeholder */
        }
    </style>
</head>
<body class="antialiased">
    <!-- Header Section -->
    <header class="bg-blue-600 text-white shadow-lg py-4">
        <div class="container flex justify-between items-center">
            <h1 class="text-3xl font-bold rounded-md px-3 py-1 bg-blue-700">My Files</h1>
            <nav>
                <ul class="flex space-x-6">
                    <li><a href="#" class="hover:text-blue-200 transition duration-300 rounded-md px-3 py-2 hover:bg-blue-700">Home</a></li>
                    <li><a href="#" class="hover:text-blue-200 transition duration-300 rounded-md px-3 py-2 hover:bg-blue-700">About</a></li>
                    <li><a href="#" class="hover:text-blue-200 transition duration-300 rounded-md px-3 py-2 hover:bg-blue-700">Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content Section -->
    <main class="flex-grow py-8">
        <div class="container bg-white p-8 rounded-xl shadow-lg">
            <section class="mb-8">
                <h2 class="text-4xl font-extrabold text-blue-700 mb-4 rounded-md bg-blue-50 px-4 py-2 inline-block">Available Files for Download</h2>
                <p class="text-lg leading-relaxed text-gray-700 mb-6">
                    Click on any of the links below to download the corresponding file.
                </p>
                <ul class="space-y-3">'

# Set IFS to newline to correctly handle filenames with spaces
IFS=$'\n'
for filename in $(ls -1 *.usdz 2>/dev/null | sort); do
    # No need for display_name capitalization as we're using filename directly
    # display_name="${filename%.usdz}"
    # display_name=$(echo "$display_name" | sed -E 's/\b([a-z])/\U\1/g')

    # Check for a corresponding .png thumbnail
    thumbnail_file="${filename%.usdz}.png"
    thumbnail_html=""

    if [ -f "$thumbnail_file" ]; then
        thumbnail_html="<img src=\"./${thumbnail_file// /%20}\" alt=\"${filename%.usdz} Thumbnail\" class=\"w-16 h-16 object-cover rounded-md flex-shrink-0\">"
    else
        thumbnail_html="<div class=\"thumbnail-placeholder w-16 h-16 text-gray-500 rounded-md flex-shrink-0\">📦</div>"
    fi

    # Ensure filename is properly URL-encoded in the href attribute
    ENCODED_FILENAME="${filename// /%20}"

    INDEX_HTML_CONTENT+="
                    <li class=\"file-item\">
                        ${thumbnail_html}
                        <a href=\"./${ENCODED_FILENAME}\" download=\"${filename}\" class=\"text-blue-600 hover:text-blue-800 font-semibold text-lg transition duration-300 ease-in-out transform hover:scale-105 flex-grow\">
                            ${filename}
                        </a>
                        <svg class=\"w-5 h-5 text-blue-500 flex-shrink-0\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M13 7l5 5m0 0l-5 5m5-5H6\"></path></svg>
                    </li>"
done
# Reset IFS to its default value
unset IFS

# Close the HTML structure
INDEX_HTML_CONTENT+='
                </ul>
            </section>
        </div>
    </main>

    <!-- Footer Section -->
    <footer class="bg-gray-800 text-white py-6 mt-auto">
        <div class="container text-center">
            <p>&copy; 2025 My Files. All rights reserved.</p>
            <p class="text-sm mt-2">Hosted with &hearts; on GitHub Pages.</p>
        </div>
    </footer>
</body>
</html>'

# Write the content to index.html
echo "$INDEX_HTML_CONTENT" > index.html
echo "index.html has been generated with links to all .usdz files."
echo "--- Generation Complete ---"
