git clone git@github.com:xavier-ljf/skill-dispatcher.git skill-dispatcher

cd skill-dispatcher
npm install
npm run build

cd inventory


npx skills add https://github.com/vercel-labs/skills -a universal -y --skill find-skills

npx skills add obra/superpowers -a universal -y

npx skills add https://github.com/anthropics/skills -a universal -y --skill \
    skill-creator \
    frontend-design \
    webapp-testing \
    pptx \
    docx \
    xlsx \
    pdf

npx skills add https://github.com/vercel-labs/agent-skills -a universal -y --skill \
    vercel-react-best-practices \
    vercel-composition-patterns \
    web-design-guidelines

npx skills add https://github.com/jackwener/opencli -a universal -y --skill \
    opencli-usage \
    opencli-browser \
    opencli-autofix

npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser -a universal -y

npx skills add https://github.com/ant-design/antd-skill -a universal -y --skill ant-design
npx skills add https://github.com/ant-design/ant-design-cli -a universal -y --skill antd

npx skills add https://github.com/op7418/humanizer-zh -a universal -y --skill humanizer-zh 
