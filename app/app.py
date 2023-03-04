"""Image default application."""
from __future__ import annotations

from importlib import metadata

from muffin import Application

version = metadata.version("muffin")
app = Application()


@app.route("/")
async def index(request):
    """Just say hello."""
    return f"""
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
    <body class="bg-dark text-warning">
        <div class="w-100 h-100 d-flex justify-content-center align-items-center flex-column">
            <h3>Hello from Muffin {version}</h3>
            <p class="text-light">
                This is a default docker image application replace it with your code
            </p>
        </div>
    </body>

    """
