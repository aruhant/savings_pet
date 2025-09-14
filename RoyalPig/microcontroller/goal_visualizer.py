import google.generativeai as genai
import os
from dotenv import load_dotenv

# Load environment variables from a .env file
load_dotenv()

class GoalVisualizer:
    """
    An LLM-powered visual generator for savings goals.

    This class connects to the Google Gemini API to create a dynamic and
    visually appealing SVG graphic that represents the progress of a
    financial goal. The core of this class is the carefully crafted
    prompt that instructs the LLM on how to generate a creative and
    meaningful visualization.
    """

    def __init__(self):
        """
        Initializes the GoalVisualizer and configures the Gemini API.
        """
        self.api_key = os.getenv("GOOGLE_API_KEY")
        if not self.api_key:
            raise ValueError("GOOGLE_API_KEY not found in environment variables.")
        
        genai.configure(api_key=self.api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        print("🎨 Goal Visualizer initialized successfully.")

    def _construct_creative_prompt(self, goal_name, current_amount, goal_amount):
        """
        Constructs a detailed and creative prompt for the Gemini model.

        This prompt is the heart of the visualizer. It provides the necessary
        data and a set of creative guidelines and constraints to ensure a
        high-quality, relevant, and aesthetically pleasing SVG output.
        """
        if goal_amount <= 0:
            progress_percent = 0
        else:
            progress_percent = min(100, (current_amount / goal_amount) * 100)

        # A theme is chosen based on the goal name to give the LLM creative direction
        theme_suggestion = "a travel or adventure theme, like a plane flying across a map or a path up a mountain"
        if "car" in goal_name.lower():
            theme_suggestion = "an automotive theme, like a car being built or a road trip"
        elif "home" in goal_name.lower() or "house" in goal_name.lower():
            theme_suggestion = "a home or construction theme, like a house being built"

        prompt = f"""
        **Objective:** Generate a beautiful, self-contained SVG graphic to visualize a user's savings goal progress. The output must be only the raw SVG code.

        **Core Data:**
        - **Goal:** "{goal_name}"
        - **Current Savings:** ${current_amount:,.2f}
        - **Total Goal:** ${goal_amount:,.2f}
        - **Progress Percentage:** {progress_percent:.1f}%

        **Creative & Thematic Direction:**
        1.  **Theme:** The design should be inspired by **{theme_suggestion}**. Be creative and metaphorical. For example, as the percentage increases, the visual element should feel more complete (e.g., the plane gets closer to its destination, the mountain path gets higher).
        2.  **Style:** Aim for a modern, clean, and slightly playful "flat design" aesthetic. Use a sophisticated and harmonious color palette.
        3.  **Dynamic Element:** The core of the SVG must visually represent the `{progress_percent:.1f}%` progress. This is the most important part of the visualization.

        **Technical SVG Requirements:**
        - **Self-Contained:** The SVG must not have any external dependencies (no external images, fonts, or stylesheets). All styles must be inline or within a `<style>` tag inside the SVG.
        - **Dimensions:** The SVG `viewBox` should be `0 0 400 200`.
        - **Text Elements:**
            - Clearly display the Goal Name ("{goal_name}").
            - Clearly display the progress text (e.g., "${current_amount:,.2f} / ${goal_amount:,.2f}").
            - Clearly display the percentage ("{progress_percent:.1f}%").
            - Use a common, legible web-safe font like 'Verdana', 'Arial', or a sans-serif default.
            - Ensure text has good contrast against its background.
        - **Output Format:** The response MUST be the raw SVG code ONLY. Start with `<svg ...>` and end with `</svg>`. Do not include markdown, comments, or any other text.

        **Example Structure (do not copy, for inspiration only):**
        <svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id="progressGradient" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style="stop-color:#A1C4FD;" />
              <stop offset="100%" style="stop-color:#C2E9FB;" />
            </linearGradient>
          </defs>
          <rect x="0" y="0" width="400" height="200" fill="#f9f9f9" rx="15"/>
          <!-- ... Themed visualization elements here ... -->
          <rect x="20" y="120" width="360" height="20" fill="#e0e0e0" rx="10"/>
          <rect x="20" y="120" width="{360 * progress_percent / 100}" height="20" fill="url(#progressGradient)" rx="10"/>
          <text x="200" y="50" font-family="Verdana, sans-serif" font-size="20" text-anchor="middle" fill="#333">{goal_name}</text>
          <!-- ... Other text elements ... -->
        </svg>

        Now, generate the SVG based on these instructions.
        """
        return prompt.strip()

    def generate_svg(self, goal_name, current_amount, goal_amount):
        """
        Generates the SVG by calling the Gemini API with the creative prompt.

        Args:
            goal_name (str): The name of the savings goal.
            current_amount (float): The current amount saved.
            goal_amount (float): The total goal amount.

        Returns:
            str: The generated SVG content as a string, or None on failure.
        """
        print(f"Generating visualization for '{goal_name}'...")
        prompt = self._construct_creative_prompt(goal_name, current_amount, goal_amount)
        
        try:
            response = self.model.generate_content(prompt)
            svg_content = response.text

            # Clean the response to ensure it's only the SVG code
            if "```" in svg_content:
                # Strip out markdown code blocks if they exist
                svg_content = svg_content.split("```")[1].strip()
                if svg_content.startswith("svg"):
                    svg_content = svg_content[3:].strip()
            
            if not svg_content.strip().startswith("<svg"):
                print("Error: LLM response did not start with valid SVG tag.")
                print("------ LLM Response ------")
                print(svg_content)
                print("--------------------------")
                return None

            print("✅ SVG generation successful.")
            return svg_content

        except Exception as e:
            print(f"❌ An error occurred during SVG generation: {e}")
            return None

# --- Example Usage ---
if __name__ == '__main__':
    # This block demonstrates how to use the GoalVisualizer class.
    # In your actual application, you would import and use it similarly.
    
    # --- Configuration ---
    # The output path for the generated SVG file.
    # This places it in the 'assets' folder, one level up.
    SVG_OUTPUT_PATH = os.path.join("..", "assets", "goal_progress.svg")

    # --- Mock Goal Data ---
    # In a real application, this data would come from your DynamoDB stream listener.
    my_goal = "Dream Vacation to Japan"
    current_savings = 3250.50
    total_goal = 7000.0

    # --- Generation ---
    visualizer = GoalVisualizer()
    generated_svg = visualizer.generate_svg(my_goal, current_savings, total_goal)

    # --- Saving the Output ---
    if generated_svg:
        try:
            os.makedirs(os.path.dirname(SVG_OUTPUT_PATH), exist_ok=True)
            with open(SVG_OUTPUT_PATH, "w") as f:
                f.write(generated_svg)
            print(f"🖼️  Successfully saved the goal visualization to: {SVG_OUTPUT_PATH}")
        except IOError as e:
            print(f"❌ Failed to write SVG file: {e}")
    else:
        print("SVG generation failed. No file was saved.")
