-- CreateEnum
CREATE TYPE "Role" AS ENUM ('admin', 'artist', 'producer', 'collaborator');

-- CreateEnum
CREATE TYPE "Genre" AS ENUM ('pop', 'hiphop', 'rock', 'electronic', 'jazz', 'classical', 'rnb', 'country', 'other');

-- CreateEnum
CREATE TYPE "SessionStatus" AS ENUM ('planned', 'in_progress', 'completed');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "display_name" TEXT NOT NULL,
    "bio" TEXT NOT NULL,
    "avatar_url" TEXT NOT NULL,
    "social_links" JSONB NOT NULL,
    "is_public" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "clerkUserId" TEXT NOT NULL,
    "clerkPrimaryEmailId" TEXT,
    "clerkExternalId" TEXT,
    "clerkUsername" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Song" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "artist_id" UUID NOT NULL,
    "album" TEXT NOT NULL,
    "genre" TEXT NOT NULL,
    "bpm" INTEGER NOT NULL,
    "key_signature" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "release_date" DATE NOT NULL,
    "file_url" TEXT NOT NULL,
    "cover_art_url" TEXT NOT NULL,
    "lyrics" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "seo_title" TEXT NOT NULL,
    "seo_description" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "is_public" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "Song_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Studio_Session" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "creator_id" UUID NOT NULL,
    "session_date" DATE NOT NULL,
    "location" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "status" "SessionStatus" NOT NULL,
    "notes" TEXT NOT NULL,
    "equipment" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "Studio_Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Collaboration" (
    "id" UUID NOT NULL,
    "song_id" UUID,
    "session_id" UUID,
    "user_id" UUID NOT NULL,
    "role" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Collaboration_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkUserId_key" ON "User"("clerkUserId");

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkExternalId_key" ON "User"("clerkExternalId");

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkUsername_key" ON "User"("clerkUsername");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_clerkUserId_idx" ON "User"("clerkUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Song_slug_key" ON "Song"("slug");

-- CreateIndex
CREATE INDEX "Song_artist_id_idx" ON "Song"("artist_id");

-- CreateIndex
CREATE INDEX "Song_slug_idx" ON "Song"("slug");

-- CreateIndex
CREATE INDEX "Song_is_public_release_date_idx" ON "Song"("is_public", "release_date");

-- CreateIndex
CREATE INDEX "Studio_Session_creator_id_idx" ON "Studio_Session"("creator_id");

-- CreateIndex
CREATE INDEX "Studio_Session_session_date_idx" ON "Studio_Session"("session_date");

-- CreateIndex
CREATE INDEX "Studio_Session_status_idx" ON "Studio_Session"("status");

-- CreateIndex
CREATE INDEX "Collaboration_song_id_idx" ON "Collaboration"("song_id");

-- CreateIndex
CREATE INDEX "Collaboration_session_id_idx" ON "Collaboration"("session_id");

-- CreateIndex
CREATE INDEX "Collaboration_user_id_idx" ON "Collaboration"("user_id");

-- AddForeignKey
ALTER TABLE "Song" ADD CONSTRAINT "Song_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Studio_Session" ADD CONSTRAINT "Studio_Session_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collaboration" ADD CONSTRAINT "Collaboration_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "Song"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collaboration" ADD CONSTRAINT "Collaboration_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "Studio_Session"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collaboration" ADD CONSTRAINT "Collaboration_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
