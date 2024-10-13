# Important: Mind the trailing slashes
POSTS_SOURCE_DIR="/Users/fotis/Library/Mobile Documents/com~apple~CloudDocs/Documents/Blogging/Personal Blog/Published/"
POSTS_WORK_DIR="/Users/fotis/Library/Mobile Documents/com~apple~CloudDocs/Documents/Blogging/Personal Blog/Work/"
TARGET_POSTS_DIR := "./_posts/"
TARGET_WORK_DIR := "./_work/"
DATE := `date '+%Y-%m-%d %H:%M:%S'`

sync-posts:
	rsync --archive --verbose --recursive --delete $(POSTS_SOURCE_DIR) $(TARGET_POSTS_DIR)

sync-work:
	rsync --archive --verbose --recursive --delete $(POSTS_WORK_DIR) $(TARGET_WORK_DIR)

sync: sync-posts sync-work

publish-posts:
	sync
	git add -- _posts _work
	git commit -m "Update posts $(DATE)"
	git push origin master
