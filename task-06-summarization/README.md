# Task 06: Summarization Engine

## 📌 Objective
Summarize large operational and compliance documents (e.g., safety audits, maintenance logs, compliance reviews) into concise, actionable summaries.

---

## ⚙️ Tech Stack
- **Groq API** with LLaMA model (`llama-3.3-70b-versatile`)
- **LangChain** for text splitting and summarization chaining
- **PyPDFLoader / TextLoader** for loading PDF or text documents
- **Python 3.10+**  

---

## 🛠 Key Features
1. **Summarization Chains**
   - Uses **MapReduce-style summarization**:
     - **Map**: Split large documents into chunks and summarize each chunk individually.
     - **Reduce**: Combine chunk summaries into a final coherent summary.
   - This method ensures:
     - No loss of context in long documents
     - Faster processing and reliable summaries
   - Optional: Can use **Refine chains** for iterative improvement of summaries (not implemented in this script but supported by LangChain).

2. **Chunking Mechanism**
   - Large documents are split into smaller **chunks** (e.g., 2000 characters with 200-character overlap) using **LangChain’s `RecursiveCharacterTextSplitter`**.
   - **Overlap** ensures continuity between chunks so context isn’t lost between sections.
   - Each chunk is summarized individually by the Groq LLaMA model and then combined.

3. **Supported Document Types**
   - PDF (`.pdf`)
   - Text (`.txt`)

4. **Output**
   - Summaries are combined into a single file: `final_summary.txt`
   - Prints a preview of the summary in console.

---

## 🏃 How to Run
1. Place your documents in the `sample_documents/` folder.
2. Set your **Groq API key** in the script:
   ```python
   api_key = "your_api_key_here"
