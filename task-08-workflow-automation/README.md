# Task 08: Workflow Automation with n8n

## 📌 Objective
Automate operational alerts, supplier communications, and QA logging using **n8n** workflows. The workflow integrates outputs from LangChain pipelines via webhooks.

---

## ⚙️ Tech Stack / Tools
- **n8n.io** (cloud or self-hosted)  
- **Nodes Used**:
  - **Webhook**: Receives payload from LangChain outputs (summarization, RAG, SQL).  
  - **Slack**: Sends real-time alerts to channels.  
  - **Gmail / Email**: Sends automated emails to suppliers or supervisors.  
  - **HTTP Request**: Interacts with external APIs.  
  - **Google Sheets / Airtable**: Logs QA or summarization results.  

---

## 🔹 Flow Setup
1. **Webhook Trigger**
   - A webhook node listens for POST requests from your LangChain or SQL pipeline.
   - Example payload:
     ```json
     {
       "summary": "Machine downtime exceeded threshold",
       "downtime_hours": 5,
       "sentiment_score": -0.7
     }
     ```

2. **Conditional Nodes**
   - Check for thresholds:
     - `downtime_hours > 4` → trigger Slack/email alert.
     - `defect_rate > 5%` → trigger QA notification.
     - `investment > 50L` → trigger client email.

3. **Action Nodes**
   - **Slack**: Send message to operational or QA channel.
   - **Gmail**: Send email to supervisor or supplier.
   - **Google Sheets / Airtable**: Log summary, sentiment, or alert details for record keeping.

4. **Transformation / Formatting**
   - Use **Function nodes** to format LangChain output into readable messages for Slack/email/Sheets.

---

## 🔹 How Webhook Integrates with LangChain
- LangChain pipeline outputs JSON via **HTTP POST** to the n8n webhook.  
- The webhook node receives data and passes it through the workflow:
  1. **Transform payload** → Function Node  
  2. **Conditional logic** → IF Node (thresholds)  
  3. **Send output** → Slack / Gmail / Sheets nodes  

- Example integration in Python (FastAPI):
  ```python
  import requests

  payload = {
      "summary": "Negative sentiment detected in QA logs",
      "sentiment_score": -0.8
  }
  webhook_url = "https://<your-n8n-domain>/webhook/langchain-alert"
  requests.post(webhook_url, json=payload)
