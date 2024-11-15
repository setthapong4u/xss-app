from flask import Flask, request, render_template_string

app = Flask(__name__)

# Simulated database for comments
comments = []

@app.route('/', methods=['GET', 'POST'])
def index():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    
    if request.method == 'POST':
        # Vulnerable code: stores unsanitized user input
        comment = request.form['comment']
        comments.append({'text': comment, 'ip': client_ip})
    
    # Render the comments including unsanitized input
    comment_section = "<br>".join(
        [f"{comment['ip']}: {comment['text']}" for comment in comments]
    )

    # Display the form and the comments
    return render_template_string('''
        <html>
        <head><title>Vulnerable XSS Comment Section</title></head>
        <body>
            <h1>Comment Section</h1>
            <form method="post" action="/">
                <textarea name="comment" placeholder="Enter your comment here"></textarea><br>
                <button type="submit">Post Comment</button>
            </form>
            <h2>Comments:</h2>
            <div>{{ comment_section | safe }}</div>
        </body>
        </html>
    ''', comment_section=comment_section)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
